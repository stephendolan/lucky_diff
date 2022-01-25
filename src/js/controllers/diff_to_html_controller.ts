import { Controller } from "@hotwired/stimulus";

import {
  Diff2HtmlUI,
  Diff2HtmlUIConfig,
} from "diff2html/lib/ui/js/diff2html-ui-slim.js";

import "highlight.js/styles/github.css";
import "diff2html/bundles/css/diff2html.min.css";

export default class extends Controller {
  connect(): void {
    const diff2htmlUi = new Diff2HtmlUI(
      this.diffElement,
      this.unifiedDiff,
      this.diffConfiguration
    );

    diff2htmlUi.draw();
  }

  get unifiedDiff(): string {
    return this.data.get("unifiedDiff") || "";
  }

  get diffElement(): HTMLElement {
    return this.element as HTMLElement;
  }

  get diffConfiguration(): Diff2HtmlUIConfig {
    return {
      drawFileList: true,
      matching: "lines",
    };
  }
}
