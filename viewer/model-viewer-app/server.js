#!/usr/bin/env node
'use strict';

const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 8000;

app.get('/api/health', (req, res) => {
  res.json({ ok: true });
});

// Serve static frontend
const indexHtml = path.join(__dirname, 'public', 'index.html');
app.use('/static', express.static(path.join(__dirname, 'public', 'static')));
app.get(/.*/, (req, res) => res.sendFile(indexHtml));

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Model Viewer running on http://0.0.0.0:${PORT}`);
});
