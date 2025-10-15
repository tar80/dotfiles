<%*
const selection = document.getSelection();
const selectedText = selection.toString();
let searchText = selectedText;

if (!searchText) {
  selection.modify("move", "left", "paragraphboundary");
  selection.modify("extend", "right", "paragraphboundary");
  searchText = selection.toString();
  selection.removeAllRanges();
}

if (searchText) {
  open("https://www.deepl.com/ja/translator#en/ja/" + encodeURIComponent(searchText));
  return selectedText;
}
%>


