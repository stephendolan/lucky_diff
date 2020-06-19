import { Controller } from "stimulus";
import * as Diff2Html from "diff2html";
import "diff2html/bundles/css/diff2html.min.css";

export default class extends Controller {
  connect() {
    const diffJson = Diff2Html.parse(this.unifiedDiff);
    const diffHtml = Diff2Html.html(diffJson, { drawFileList: true });
    this.element.innerHTML = diffHtml;
  }

  get unifiedDiff() {
    return this.data.get("unifiedDiff");
  }
}
