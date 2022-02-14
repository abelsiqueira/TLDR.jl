const searchInput = document.getElementById('search-input');
const searchOutput = document.getElementById('search-output');
const radioKind = document.querySelectorAll('input[name="radio-kind"]');

const fuse = {
  'snippet': new Fuse(data.filter(item => item.kind == 'snippet'),
    {
      keys: ['description', 'command', 'tags'],
      includeScore: true,
      includeMatches: true,
    }),
  'package': new Fuse(data.filter(item => item.kind == 'header'),
    {
      keys: ['package', 'description'],
      includeScore: true,
      includeMatches: true,
    }),
  'tag': new Fuse(data,
    {
      keys: ['tags'],
      includeScore: true,
      includeMatches: true,
    }),
}


function pkgButton(pkg) {
  searchInput.value = pkg
  for (i = 0; i < radioKind.length; i++) {
    if (radioKind[i].value == 'package') {
      radioKind[i].checked = true
    } else {
      radioKind[i].checked = false
    }
  }
  inputHandler()
}

function tagButton(tag) {
  searchInput.value = tag
  for (i = 0; i < radioKind.length; i++) {
    if (radioKind[i].value == 'tags') {
      radioKind[i].checked = true
    } else {
      radioKind[i].checked = false
    }
  }
  inputHandler()
}



function parse_cmd(cmd) {
  if (cmd === '') {
    return '';
  } else {
    out = '<code>' + cmd.split('\n').join('<br>') + '</code>'
    return out;
  }
}

function formatSnippetItem(item) {
  // command, description, kind, package, tags
  let pkg
  if (item.package != '') {
    pkg = `part of <a class="has-text-success" onclick="pkgButton(\'${item.package}\')">${item.package}.jl</a>`
  } else {
    pkg = 'no package needed'
  }
  let out = `<div class="notification is-success is-light has-text-black">
    <h3>${parse_cmd(item.command)}</h3>
    <span><strong>${pkg}</strong></span>
    ${marked.parse(item.description)}`
  for (tag of item.tags) {
    out += formatTagItem(tag)
  }
  out += '</div>'
  return out
}

function formatPackageItem(item) {
  // This is a package header item
  let out = `<div class="notification is-success is-light has-text-black">
    <div class="block">
      <h2 class="is-primary">${item.package}</h2>
      <span class="subtitle">${item.description}</span>
    </div>`
  let snippets = data.filter(i => i.kind == 'snippet' && i.package ==  item.package)
  for (snippet of snippets) {
    out += `<div class="block">
    <h4>${parse_cmd(snippet.command)}</h4>
    ${marked.parse(snippet.description)}`
    for (tag of snippet.tags) {
      out += formatTagItem(tag)
    }
    out += '</div>'
  }
  out += `</div>`
  return out
}

function formatTagItem(tag) {
  return `<button class="button is-small is-success is-outlined" onclick="tagButton(\'${tag}\')">
  <span class="icon is-small"><i class="fas fa-tag"></i></span>
  <span>${tag}</span>
  </button>\n`
  // return `<span class="tag is-primary">${tag}</span>\n`
}

function snippetSearch(input) {
  let matches = fuse.snippet.search(input);
  out = ''
  for (match of matches) {
    out += formatSnippetItem(match.item) + '\n'
  }
  return out
}

function packageSearch(input) {
  let matches = fuse.package.search(input);
  out = ''
  for (match of matches) {
    out += formatPackageItem(match.item) + '\n';
  }
  return out
}

function tagSearch(input) {
  let matches = fuse.tag.search(input);
  out = ''
  for (match of matches) {
    out += formatSnippetItem(match.item) + '\n'
  }
  return out
}

const inputHandler = function(e) {
  // snippet
  let checkedRadio
  for (radio of radioKind) {
    if (radio.checked) checkedRadio = radio.value;
  }
  if (checkedRadio == 'snippet') {
    out = snippetSearch(searchInput.value);
  } else if (checkedRadio == 'package') {
    out = packageSearch(searchInput.value);
  } else {
    out = tagSearch(searchInput.value);
  }
  searchOutput.innerHTML = out
}

searchInput.addEventListener('input', inputHandler);
searchInput.addEventListener('propertychange', inputHandler);
for (i = 0; i < radioKind.length; i++) {
  radioKind[i].addEventListener('change', inputHandler);
}