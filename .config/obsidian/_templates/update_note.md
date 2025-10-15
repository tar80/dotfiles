<%*
const DATE_KEY = 'date';
const DATE_FORMAT = 'YYYY-MM-DD';
const DELIMITER = '---';
const vault = app.vault.adapter;
const workspace = app.workspace;
const fileObj = workspace.getActiveFile();

if (!fileObj) {
  new Notice('No active file found.');
  return;
}

async function getFileContent(file) {
  if (!file) {
    console.error('File is null or undefined.');
    return '';
  }
  try {
    const adapter = app.vault.adapter;
    if (adapter && adapter.read) {
      return await adapter.read(file.path);
    } else {
      console.error('app.vault.adapter is not available.');
      return '';
    }
  } catch (err) {
    console.error('Error reading file:', err);
    new Notice('Failed to read file.');
    return '';
  }
}

async function writeFileContent(file, content) {
  try {
    await app.vault.adapter.write(file.path, content);
  } catch (err) {
    console.error('Error writing file:', err);
    new Notice('Failed to write file.');
  }
}

const fileContent = await getFileContent(fileObj);
const hasFrontmatter = Object.keys(tp.frontmatter).length > 0;
const newDate = tp.date.now(DATE_FORMAT);
let replacedContent;

if (hasFrontmatter) {
  const newDatetime = `${DATE_KEY}: ${newDate}`;
  const frontmatterEndIndex = fileContent.indexOf(DELIMITER, 3);

  if (frontmatterEndIndex !== -1) {
    let lines = fileContent.split('\n');
    let dateUpdated = false;

    for (let i = 0; i < frontmatterEndIndex; i++) {
      if (lines[i].startsWith(`${DATE_KEY}:`)) {
        lines[i] = newDatetime;
        dateUpdated = true;
        break;
      }
    }

    if (!dateUpdated) {
      lines.splice(frontmatterEndIndex, 0, newDatetime);
    }

    replacedContent = lines.join('\n');
  } else {
    const frontmatterBody = `${DELIMITER}\n${newDatetime}\n${DELIMITER}`.trim();
    replacedContent = `${frontmatterBody}\n${fileContent}`;
  }

  if (tp.file.folder() !== '_drafts') {
    await writeFileContent(fileObj, replacedContent);
    return
  }

  replacedContent = replacedContent.replace(/\!\[\[\.\.\/(.*?)\]\]/g, (match, p1) => {
    return `![image]{{ site.baseurl }}{% link ${p1} %}`;
  });
  replacedContent = replacedContent.replace(/\[\[\.\.\/_posts\/(.*?)\]\]/g, (match, p1) => {
    return `[article]{{ site.baseurl }}{% post_url ${p1} %}`;
  });

  await writeFileContent(fileObj, replacedContent);

  try {
    if (fileObj) {
      const newName = `${newDate.slice(2)}-${fileObj.basename}`;
      await tp.file.move(`_posts/${newName}`);
      new Notice(`${fileObj.name} moved to _posts/${newName}`);
    }
  } catch (err) {
    new Notice(`Failed to move file: ${err}`);
  }
}
-%>