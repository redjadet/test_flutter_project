#!/usr/bin/env node
/*
 Normalizes ARB files under l10n/ without requiring Dart:
 - Pretty prints with 2 spaces
 - Sorts message keys alphabetically (case-insensitive)
 - Ensures metadata entries ("@key") exist with a placeholder description
 - Keeps "@@locale" first if present
 - Preserves other top-level metadata like @@last_modified
*/

const fs = require('fs');
const path = require('path');

async function listArbFiles(dir) {
  try {
    const entries = await fs.promises.readdir(dir, { withFileTypes: true });
    return entries
      .filter((e) => e.isFile() && e.name.endsWith('.arb'))
      .map((e) => path.join(dir, e.name));
  } catch {
    return [];
  }
}

function normalizeMap(map) {
  const out = {};

  if (Object.prototype.hasOwnProperty.call(map, '@@locale')) {
    out['@@locale'] = map['@@locale'];
  }

  const baseKeys = Object.keys(map)
    .filter((k) => !k.startsWith('@') && k !== '@@locale')
    .sort((a, b) => a.toLowerCase().localeCompare(b.toLowerCase()))

  for (const key of baseKeys) {
    out[key] = map[key];
    const metaKey = `@${key}`;
    if (Object.prototype.hasOwnProperty.call(map, metaKey)) {
      out[metaKey] = map[metaKey];
    } else {
      out[metaKey] = { description: `TODO: add description for "${key}"` };
    }
  }

  // Copy remaining top-level metadata entries (keys starting with @@)
  for (const [k, v] of Object.entries(map)) {
    if (k === '@@locale') continue;
    if (k.startsWith('@@') && !Object.prototype.hasOwnProperty.call(out, k)) {
      out[k] = v;
    }
  }

  return out;
}

async function normalizeFile(file) {
  try {
    const raw = await fs.promises.readFile(file, 'utf8');
    const data = JSON.parse(raw);
    const normalized = normalizeMap(data);
    const text = JSON.stringify(normalized, null, 2) + '\n';
    if (text !== raw) {
      await fs.promises.writeFile(file, text, 'utf8');
      process.stdout.write(`[fix_arb_node] Formatted ${file}\n`);
    }
  } catch (e) {
    process.stderr.write(`[fix_arb_node] Skipped ${file}: ${e.message}\n`);
  }
}

async function main() {
  const repoRoot = process.cwd();
  const l10nDir = path.join(repoRoot, 'l10n');
  const files = await listArbFiles(l10nDir);
  await Promise.all(files.map(normalizeFile));
}

main();

