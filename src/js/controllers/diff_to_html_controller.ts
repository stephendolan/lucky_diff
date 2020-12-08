import { Controller } from "stimulus";
import * as Diff2Html from "diff2html";

export default class extends Controller {
  connect(): void {
    const diffJson = Diff2Html.parse(this.unifiedDiff);
    const diffHtml = Diff2Html.html(diffJson, { drawFileList: false });
    this.element.innerHTML = diffHtml;
  }

  get unifiedDiff(): string {
    return this.data.get("unifiedDiff") || "";
  }
}
