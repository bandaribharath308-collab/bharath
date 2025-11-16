const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require('url');

const PORT = process.env.PORT || 3000;
const ROOT = path.resolve(__dirname);

function contentType(filePath) {
  const ext = path.extname(filePath).toLowerCase();
  const map = {
    '.html': 'text/html; charset=utf-8',
    '.css': 'text/css; charset=utf-8',
    '.js': 'application/javascript; charset=utf-8',
    '.json': 'application/json; charset=utf-8',
    '.png': 'image/png',
    '.jpg': 'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.svg': 'image/svg+xml',
    '.webp': 'image/webp'
  };
  return map[ext] || 'application/octet-stream';
}

function sendFile(res, filePath) {
  fs.readFile(filePath, (err, data) => {
    if (err) return send404(res);
    res.writeHead(200, { 'Content-Type': contentType(filePath), 'Access-Control-Allow-Origin': '*' });
    res.end(data);
  });
}

function sendJSON(res, obj, status = 200) {
  res.writeHead(status, { 'Content-Type': 'application/json; charset=utf-8', 'Access-Control-Allow-Origin': '*' });
  res.end(JSON.stringify(obj, null, 2));
}

function send404(res) {
  res.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
  res.end('Not found');
}

function listStates() {
  const dir = path.join(ROOT, 'states');
  try {
    return fs.readdirSync(dir).filter(f => f.endsWith('.html'));
  } catch (e) {
    return [];
  }
}

function extractTitle(html) {
  const m = html.match(/<h1[^>]*>([^<]+)<\/h1>/i);
  return m ? m[1].trim() : null;
}

function readBody(req) {
  return new Promise((resolve, reject) => {
    let body = '';
    req.on('data', chunk => (body += chunk));
    req.on('end', () => resolve(body));
    req.on('error', reject);
  });
}

const server = http.createServer(async (req, res) => {
  const parsed = url.parse(req.url, true);
  const pathname = decodeURIComponent(parsed.pathname);

  // API routes
  if (pathname === '/api/states' && req.method === 'GET') {
    const files = listStates();
    const out = files.map(f => {
      const slug = path.basename(f, '.html');
      const html = fs.readFileSync(path.join(ROOT, 'states', f), 'utf8');
      return { slug, title: extractTitle(html) || slug };
    });
    return sendJSON(res, out);
  }

  if (pathname.startsWith('/api/state/') && req.method === 'GET') {
    const slug = pathname.replace('/api/state/', '');
    const file = path.join(ROOT, 'states', slug + '.html');
    if (!fs.existsSync(file)) return send404(res);
    const html = fs.readFileSync(file, 'utf8');
    // return the main content (between <main>..</main>) if present, otherwise full HTML
    const m = html.match(/<main[^>]*>([\s\S]*?)<\/main>/i);
    const main = m ? m[1].trim() : html;
    return sendJSON(res, { slug, html: main });
  }

  // GET /api/state-json/:slug -> parsed sections as structured JSON
  if (pathname.startsWith('/api/state-json/') && req.method === 'GET') {
    const slug = pathname.replace('/api/state-json/', '');
    const file = path.join(ROOT, 'states', slug + '.html');
    if (!fs.existsSync(file)) return send404(res);
    const html = fs.readFileSync(file, 'utf8');
    const m = html.match(/<main[^>]*>([\s\S]*?)<\/main>/i);
    const mainHtml = m ? m[1].trim() : html;

    // Helper: extract sections by <h2> headings inside main
    const sections = [];
    // match <section>...</section> blocks and capture inner content
    const sectionRegex = /<section[^>]*>([\s\S]*?)<\/section>/gi;
    let match;
    while ((match = sectionRegex.exec(mainHtml)) !== null) {
      const block = match[1];
      // find a heading within the block (h2 or h3)
      const hMatch = block.match(/<h2[^>]*>([^<]+)<\/h2>/i) || block.match(/<h3[^>]*>([^<]+)<\/h3>/i);
      const title = hMatch ? hMatch[1].trim() : null;
      const inner = block.trim();
      // extract images (prefer srcset first entry, then src)
      const imgs = [];
      const imgRegex = /<img[^>]*?(?:srcset=["']([^"']+)["'][^>]*|src=["']([^"']+)["'])[\s\S]*?>/gi;
      let im;
      while ((im = imgRegex.exec(inner)) !== null) {
        const srcset = im[1];
        const src = im[2];
        if (srcset) {
          const first = srcset.split(',')[0].trim().split(' ')[0];
          imgs.push(first);
        } else if (src) imgs.push(src);
      }
      // extract figures with figcaption
      const figs = [];
      const figRegex = /<figure[^>]*>([\s\S]*?)<\/figure>/gi;
      let fg;
      while ((fg = figRegex.exec(inner)) !== null) {
        const figHtml = fg[1];
        const imgm = figHtml.match(/<img[^>]+src=["']([^"']+)["'][^>]*>/i);
        const capm = figHtml.match(/<figcaption[^>]*>([\s\S]*?)<\/figcaption>/i);
        figs.push({ img: imgm ? imgm[1] : null, caption: capm ? capm[1].replace(/<[^>]+>/g, '').trim() : null });
      }
      // extract list items
      const lis = [];
      const liRegex = /<li[^>]*>([\s\S]*?)<\/li>/gi;
      let li;
      while ((li = liRegex.exec(inner)) !== null) {
        const txt = li[1].replace(/<[^>]+>/g, '').trim();
        if (txt) lis.push(txt);
      }
      // extract plain text (strip tags and excessive whitespace)
      const text = inner.replace(/<[^>]+>/g, ' ').replace(/\s+/g, ' ').trim();
      sections.push({ title, html: inner, text, images: imgs, figures: figs, list: lis });
    }

    // Also attempt to extract the page H1 title
    const titleMatch = html.match(/<h1[^>]*>([^<]+)<\/h1>/i);
    const pageTitle = titleMatch ? titleMatch[1].trim() : slug;

    return sendJSON(res, { slug, title: pageTitle, sections });
  }

  if (pathname.startsWith('/api/images/') && req.method === 'GET') {
    const slug = pathname.replace('/api/images/', '');
    const dir = path.join(ROOT, 'assets', 'images', slug);
    if (!fs.existsSync(dir)) return send404(res);
    const items = fs.readdirSync(dir).filter(Boolean);
    return sendJSON(res, { slug, images: items });
  }

  if (pathname.startsWith('/api/attractions/') && req.method === 'GET') {
    const slug = pathname.replace('/api/attractions/', '');
    const dataFile = path.join(ROOT, 'data', 'attractions.json');
    let mapping = {};
    try { mapping = JSON.parse(fs.readFileSync(dataFile, 'utf8')); } catch (e) {}
    const items = mapping[slug] || [];
    // Build OSM/OSRM links that center on the attraction and include a loc param
    const enriched = items.map(it => {
      if (it.lat && it.lon) {
        const center = `${it.lat},${it.lon}`;
        // map.project-osrm.org with center & loc - works as a directions/map preview
        const osrm = `https://map.project-osrm.org/?z=13&center=${center}&loc=${it.lat},${it.lon}`;
        return { ...it, osrm_url: osrm };
      }
      return it;
    });
    return sendJSON(res, { slug, attractions: enriched });
  }

  // GET /api/contacts -> return stored contacts
  if (pathname === '/api/contacts' && req.method === 'GET') {
    const contactsFile = path.join(ROOT, 'data', 'contacts.json');
    let arr = [];
    try { arr = JSON.parse(fs.readFileSync(contactsFile, 'utf8')); } catch (e) {}
    return sendJSON(res, { contacts: arr });
  }

  if (pathname === '/api/contact' && req.method === 'POST') {
    try {
      const body = await readBody(req);
      const json = JSON.parse(body || '{}');
      const { name, email, message } = json;
      if (!name || !message) return sendJSON(res, { error: 'name and message required' }, 400);
      const contactsFile = path.join(ROOT, 'data', 'contacts.json');
      let arr = [];
      try { arr = JSON.parse(fs.readFileSync(contactsFile, 'utf8')); } catch (e) {}
      const entry = { id: Date.now(), name, email: email || null, message, ts: new Date().toISOString() };
      arr.push(entry);
      fs.writeFileSync(contactsFile, JSON.stringify(arr, null, 2), 'utf8');
      return sendJSON(res, { ok: true, entry }, 201);
    } catch (e) {
      return sendJSON(res, { error: 'invalid json' }, 400);
    }
  }

  // Serve static files from repo root
  let filePath = path.join(ROOT, pathname === '/' ? 'index.html' : pathname);
  // Prevent directory traversal
  if (!filePath.startsWith(ROOT)) return send404(res);
  // If path is a directory, try index.html
  if (fs.existsSync(filePath) && fs.statSync(filePath).isDirectory()) {
    const idx = path.join(filePath, 'index.html');
    if (fs.existsSync(idx)) filePath = idx;
  }
  if (fs.existsSync(filePath) && fs.statSync(filePath).isFile()) {
    return sendFile(res, filePath);
  }

  // fallback 404
  send404(res);
});

server.listen(PORT, () => {
  console.log(`Server listening on http://127.0.0.1:${PORT}`);
});

// Graceful shutdown
process.on('SIGINT', () => process.exit(0));
