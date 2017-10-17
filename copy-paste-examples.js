'use strict';

require('loud-rejection')();
const globby = require('globby');
const pify = require('pify');
const path = require('path');
const fs = require('fs');
const del = require('del');
const execall = require('execall');
const execa = require('execa');
const stripIndent = require('strip-indent');
const indentString = require('indent-string');
const pFinally = require('p-finally');
const timeStamp = require('time-stamp');

const helpDir = path.join(__dirname, 'help');
const copyGlob = path.join(__dirname, '**/*.{m,swift}');
const copySnippetRegExp = /\/\/[ ]*#-code-snippet:[ ]*(\S+)[ ]+([\S]+)(?:\r?\n)+([\s\S]+?)(?:\r?\n)+[ \t]*\/\/[ ]*#-end-code-snippet/g;
const pasteGlob = path.join(helpDir, '**/*.md');
const pasteSnippetRegExp = /([ \t]*\{%[ ]*comment[ ]*%\}[ ]*insert-code-snippet:[ ]+(\S+)[ ]+(\S+)[ ]+(\S+)[ ]*\{%[ ]*endcomment[ ]*%\})([\s\S+?]\{%[ ]*comment[ ]*%\}[ ]*end-code-snippet[ ]*\{%[ ]*endcomment[ ]*%\}[ \t]*)?/g;
const HELP_REPO_SSH_URL = 'git@github.com:mapbox/help.git';

const snippets = new Map();

function registerMatch(match) {
  const helpDocPermalink = match.sub[0];
  const stepName = match.sub[1];
  const snippet = stripIndent(match.sub[2]);
  if (!snippets.has(helpDocPermalink)) {
    snippets.set(helpDocPermalink, new Map());
  }
  snippets.get(helpDocPermalink).set(stepName, snippet);
}

function copySnippets(filename) {
  return pify(fs.readFile)(filename, 'utf8').then(code => {
    const matches = execall(copySnippetRegExp, code);
    if (matches.length === 0) return;
    matches.forEach(registerMatch);
  });
}

function cloneHelp() {
  return execa.shell(
    `git clone --depth 1 --branch ios-doc-testing ${HELP_REPO_SSH_URL} help`,
    { cwd: __dirname }
  );
}

function pasteReplacer(
  match,
  startComment,
  platform,
  helpDocPermalink,
  stepName,
  endComment
) {
  const indentationChar = /^\t/.test(startComment) ? '\t' : ' ';
  let indentationCount = 0;
  const indentationMatch = startComment.match(
    new RegExp(`^[${indentationChar}]+`)
  );
  if (indentationMatch) {
    indentationCount = indentationMatch[0].length;
  }
  const indent = text =>
    indentString(text, indentationCount, { indent: indentationChar });
  endComment = endComment || indent('{% comment %}end-code-snippet{% endcomment %}');

  const snippetNotFoundError = new Error(
    `Help wants snippet "${helpDocPermalink} ${stepName}", but it was not found in the source files`
  );
  let snippet;
  try {
    snippet = snippets.get(helpDocPermalink).get(stepName);
  } catch (snippetError) {
    throw snippetNotFoundError;
  }
  if (!snippet) {
    throw snippetNotFoundError;
  }
  return `${startComment}\n${indent(snippet)}\n${endComment}`;
}

function pasteSnippets(filename) {
  return pify(fs.readFile)(filename, 'utf8').then(code => {
    const updatedCode = code.replace(pasteSnippetRegExp, pasteReplacer);
    return pify(fs.writeFile)(filename, updatedCode);
  });
}

function createPr() {
  const branchName = `update-examples-${timeStamp('YYYY-MM-DD_mm-ss')}`;
  return execa.shell(
    `git checkout -b ${branchName} && git add -A && git commit -m "Update examples" && git push -u origin ${branchName}`,
    { cwd: helpDir }
  ).then(() => {
    console.log(`Pushed new branch "${branchName}". Go open a PR!`);
  });
}

function copyPasteExamples() {
  return globby(copyGlob)
    .then(filenames => {
      console.log('Copying snippets ...');
      return Promise.all(filenames.map(copySnippets));
    })
    .then(() => {
      console.log('Cloning help ...');
      return cloneHelp();
    })
    .then(() => globby(pasteGlob))
    .then(filenames => {
      console.log('Pasting snippets ...');
      return Promise.all(filenames.map(pasteSnippets));
    })
    .then(() => {
      console.log('Creating new branch ...');
      return createPr();
    });
}

function destroyHelp() {
  return del(path.join(__dirname, 'help'));
}

return pFinally(copyPasteExamples(), destroyHelp);
