<%*
const title = await tp.system.prompt("Enter title")
if (!title) {
  return
}

const filePath = `_drafts/${title}.md`
if (await tp.file.exists(title)) {
  new Notice(`⚠️ Error: ${filePath} is already existed.`)
  return
}

await app.vault.create(filePath, "")
await app.workspace.openLinkText(title, filePath, true)
%>