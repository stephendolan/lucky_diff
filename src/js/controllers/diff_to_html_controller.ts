import { Controller } from "@hotwired/stimulus";

import {
  Diff2HtmlUI,
  Diff2HtmlUIConfig,
} from "diff2html/lib/ui/js/diff2html-ui-slim.js";

import "highlight.js/styles/github.css";
import "diff2html/bundles/css/diff2html.min.css";

export default class extends Controller {
  static targets = ["viewMode", "content", "modeInput", "filesChangedTitle"];
  declare readonly viewModeTarget: HTMLSelectElement;
  declare readonly hasViewModeTarget: boolean;
  declare readonly contentTarget: HTMLElement;
  declare readonly hasContentTarget: boolean;
  declare readonly modeInputTarget: HTMLInputElement;
  declare readonly hasModeInputTarget: boolean;
  declare readonly filesChangedTitleTarget: HTMLElement;
  declare readonly hasFilesChangedTitleTarget: boolean;
  
  private abortController?: AbortController;

  connect(): void {
    // Set initial view mode from data attribute if provided
    const initialMode = this.data.get("initialMode");
    if (initialMode && this.hasViewModeTarget) {
      this.viewModeTarget.value = initialMode;
    }
    this.render();
  }
  
  disconnect(): void {
    // Cancel any pending requests when controller disconnects
    if (this.abortController) {
      this.abortController.abort();
      this.abortController = undefined;
    }
  }

  render(): void {
    // Cancel any pending requests before rendering new content
    if (this.abortController) {
      this.abortController.abort();
      this.abortController = undefined;
    }
    
    const viewMode = this.hasViewModeTarget ? this.viewModeTarget.value : "unified";
    const targetElement = this.hasContentTarget ? this.contentTarget : this.element.querySelector('.p-4 > div') as HTMLElement;
    
    if (!targetElement) {
      console.error('No target element found for diff rendering');
      return;
    }
    
    // Clear existing content
    targetElement.innerHTML = "";
    
    // Update header based on view mode
    this.updateHeader(viewMode);
    
    if (viewMode === "raw") {
      this.renderRawDiff(targetElement);
    } else if (viewMode === "commits") {
      this.renderCommits(targetElement);
    } else {
      const diff2htmlUi = new Diff2HtmlUI(
        targetElement,
        this.unifiedDiff,
        this.getDiffConfiguration(viewMode)
      );

      diff2htmlUi.draw();
      diff2htmlUi.highlightCode();
      
      // Add smooth scrolling to file links
      this.addSmoothScrolling();
    }
  }
  
  updateHeader(viewMode: string): void {
    // Header stays the same for all view modes
    // No need to show/hide anything
  }

  renderRawDiff(targetElement: HTMLElement): void {
    const rawContainer = document.createElement("div");
    rawContainer.className = "bg-gray-900 text-gray-100 p-6 rounded-lg font-mono text-sm overflow-x-auto";
    
    const pre = document.createElement("pre");
    pre.className = "whitespace-pre";
    pre.textContent = this.unifiedDiff;
    
    rawContainer.appendChild(pre);
    targetElement.appendChild(rawContainer);
    
    // Add copy button
    const copyButton = document.createElement("button");
    copyButton.className = "absolute top-4 right-4 bg-gray-800 hover:bg-gray-700 text-white px-3 py-1 rounded text-sm transition-colors";
    copyButton.textContent = "Copy";
    copyButton.onclick = () => {
      navigator.clipboard.writeText(this.unifiedDiff);
      copyButton.textContent = "Copied!";
      setTimeout(() => { copyButton.textContent = "Copy"; }, 2000);
    };
    
    rawContainer.style.position = "relative";
    rawContainer.appendChild(copyButton);
  }

  addSmoothScrolling(): void {
    const fileLinks = this.element.querySelectorAll('.d2h-file-list a');
    fileLinks.forEach(link => {
      link.addEventListener('click', (e) => {
        e.preventDefault();
        const href = link.getAttribute('href');
        if (href) {
          const target = document.querySelector(href);
          target?.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
      });
    });
  }

  viewModeChanged(): void {
    const newMode = this.hasViewModeTarget ? this.viewModeTarget.value : "unified";
    
    // Update the hidden input
    if (this.hasModeInputTarget) {
      this.modeInputTarget.value = newMode;
    }
    
    // Update URL without reloading
    const url = new URL(window.location.href);
    url.searchParams.set('mode', newMode);
    window.history.pushState({}, '', url.toString());
    
    this.render();
  }
  
  versionChanged(): void {
    // Submit the form when version changes
    const form = this.element.querySelector('form');
    if (form) {
      form.submit();
    }
  }
  
  formChanged(event: Event): void {
    // Prevent default only if it's a select change (not form submission)
    const target = event.target as HTMLElement;
    if (target.tagName === 'SELECT' && target.id === 'view-mode') {
      event.preventDefault();
    }
  }

  get unifiedDiff(): string {
    return this.data.get("unifiedDiff") || "";
  }


  getDiffConfiguration(viewMode: string): Diff2HtmlUIConfig {
    const baseConfig: Diff2HtmlUIConfig = {
      drawFileList: false,
      matching: "lines",
      outputFormat: viewMode === "side" ? "side-by-side" : "line-by-line",
      highlight: true,
      fileContentToggle: true
    };

    return baseConfig;
  }

  async renderCommits(targetElement: HTMLElement): Promise<void> {
    // Extract from and to versions from the URL
    const urlParams = new URLSearchParams(window.location.search);
    const from = urlParams.get('from') || '1.3.0';
    const to = urlParams.get('to') || '1.4.0';
    
    // Show loading state
    targetElement.innerHTML = '<div class="text-center py-8 text-gray-500">Loading commits...</div>';
    
    // Create a new abort controller for this request
    this.abortController = new AbortController();
    
    try {
      // Fetch commits data via API with abort signal
      const response = await fetch(`/api/commits?from=${from}&to=${to}`, {
        signal: this.abortController.signal
      });
      
      if (!response.ok) {
        throw new Error('Failed to fetch commits');
      }
      
      const data = await response.json();
      
      // Check if we're still in commits view before updating DOM
      const currentViewMode = this.hasViewModeTarget ? this.viewModeTarget.value : "unified";
      if (currentViewMode !== "commits") {
        return; // View has changed, don't update
      }
      
      // Render commits inline
      targetElement.innerHTML = this.renderCommitsHTML(data, from, to);
      
      // Add click handler for "Back to diff" functionality
      const backButton = targetElement.querySelector('[data-back-to-diff]');
      if (backButton) {
        backButton.addEventListener('click', (e) => {
          e.preventDefault();
          if (this.hasViewModeTarget) {
            this.viewModeTarget.value = 'unified';
            this.render();
          }
        });
      }
    } catch (error: any) {
      // Don't show error if request was aborted
      if (error.name === 'AbortError') {
        return;
      }
      
      console.error('Error loading commits:', error);
      
      // Check if we're still in commits view before showing error
      const currentViewMode = this.hasViewModeTarget ? this.viewModeTarget.value : "unified";
      if (currentViewMode === "commits") {
        targetElement.innerHTML = '<div class="text-center py-8 text-red-500">Error loading commits</div>';
      }
    } finally {
      // Clear the abort controller reference
      this.abortController = undefined;
    }
  }
  
  private renderCommitsHTML(data: any, from: string, to: string): string {
    const { commits, total_commits, html_url } = data;
    
    return `
      <div class="px-3">
        <ul class="divide-y divide-gray-200 border-t border-gray-200">
          ${commits.reverse().map((commit: any) => this.renderCommitItem(commit)).join('')}
        </ul>
      </div>
    `;
  }
  
  private renderCommitItem(commit: any): string {
    const author = commit.author || commit.committer;
    const date = new Date(commit.commit.author.date).toLocaleDateString('en-US', { 
      month: 'long', 
      day: 'numeric', 
      year: 'numeric' 
    });
    
    // Get just the title (first line)
    const title = commit.commit.message.split('\n')[0].trim();
    
    return `
      <li>
        <a href="${commit.html_url}" target="_blank" class="block hover:bg-gray-50 px-3 py-3 transition-colors -mx-3">
          <div class="flex items-start gap-3">
            <img src="${author.avatar_url}" alt="${author.login} avatar" class="h-8 w-8 sm:h-10 sm:w-10 rounded-full ring-1 ring-gray-300 flex-shrink-0">
            <div class="flex-1 min-w-0">
              <div class="flex items-start justify-between gap-3">
                <div class="flex-1 min-w-0">
                  <p class="text-xs sm:text-sm font-medium text-emerald-600">${commit.commit.author.name} (@${author.login})</p>
                  <p class="text-xs sm:text-sm text-gray-700 mt-0.5 break-words">${title}</p>
                  <p class="text-xs text-gray-500 mt-1">
                    <span class="inline-flex items-center">
                      <svg class="mr-1 h-3 w-3" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                      </svg>
                      Committed on ${date}
                    </span>
                  </p>
                </div>
                <svg class="h-4 w-4 sm:h-5 sm:w-5 text-gray-400 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd"></path>
                </svg>
              </div>
            </div>
          </div>
        </a>
      </li>
    `;
  }
}
