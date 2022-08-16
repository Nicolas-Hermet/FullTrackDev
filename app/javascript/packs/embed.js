import Trix from "trix"
import Rails from "@rails/ujs"

class EmbedController {
  constructor(element) {
    this.patterns = [
        /^https:\/\/([^\.]+\.)?flickr\.com\/(.*)/,
        /^https:\/\/([^\.]+\.)?gist.github\.com\/(.*)/,
        /^https:\/\/([^\.]+\.)?mixcloud\.com\/(.*)/,
        /^https:\/\/([^\.]+\.)?slideshare\.net\/(.*)/,
        /^https:\/\/([^\.]+\.)?soundcloud\.com\/(.*)/,
        /^https:\/\/([^\.]+\.)?speakerdeck\.com\/(.*)/,
        /^https:\/\/([^\.]+\.)?spotify\.com\/(.*)/,
        /^https:\/\/([^\.]+\.)?ted\.com\/(.*)/,
        /^https:\/\/([^\.]+\.)?twitter\.com\/(.*)/,
        /^https:\/\/([^\.]+\.)?vimeo\.com\/(\d*)/,
        /^https:\/\/([^\.]+\.)?youtu\.be\/(.*)/,
        /^https:\/\/([^\.]+\.)?youtube\.com\/watch\?v=(.*)/,
        /^((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube(-nocookie)?\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?$/,
      ]

    this.element = element
    this.editor = element.editor
    this.toolbar = element.toolbarElement
    this.hrefElement = this.toolbar.querySelector("[data-trix-input][name='href']")
    this.embedContainerElement = this.toolbar.querySelector("[data-behavior='embed_container']")
    this.embedElement = this.toolbar.querySelector("[data-behavior='embed_url']")

    this.reset()
    this.installEventHandlers()
  }

  installEventHandlers() {
    this.hrefElement.addEventListener("input", this.didInput.bind(this))
    this.hrefElement.addEventListener("focusin", this.didInput.bind(this))
    this.embedElement.addEventListener("click", this.embed.bind(this))
  }

  // This is called when anything is typed or pasted into the URL input field
  didInput(event) {
    let value = event.target.value.trim()

    let matches = null
    for (let i = 0; i < this.patterns.length; i++) {
      matches = value.match(this.patterns[i])
      if(matches != null) {
        break;
      }
    }

    if (matches != null) {
      // if there is a match, call fetch with the full URL (which is matches[0])
      this.fetch(matches[0])
    } else {
      // No embed, so reset the form
      this.reset()
    }
  }

  fetch(value) {
    Rails.ajax({
      url: `/embeds?url=${encodeURIComponent(value)}`,
      type: 'get',
      error: this.reset.bind(this),
      success: this.showEmbed.bind(this)
    })
  }

  embed(event) {
    if (this.currentEmbed == null) { return }
    let attachment = new Trix.Attachment(this.currentEmbed)
    this.editor.insertAttachment(attachment)
    this.element.focus()
  }

  showEmbed(embed) {
    this.currentEmbed = embed
    this.embedContainerElement.style.display = "block"
  }

  reset() {
    this.embedContainerElement.style.display = "none"
    this.currentEmbed = null
  }
}

document.addEventListener("trix-initialize", function(event) {
  const { toolbarElement } = event.target
  const buttonRow = toolbarElement.querySelector(".trix-dialog__link-fields")
  buttonRow.insertAdjacentHTML("afterend", `
        <div class="form-group mt-2 mb-0" data-behavior="embed_container">
          <div class="link_to_embed link_to_embed--new text-purple-400">
            Embed this media in your post?
            <input class="px-6 py-2 bg-purple-600 font-bold rounded ml-3" type="button" data-behavior="embed_url" value="Embed">
          </div>
        </div>
      `
  )

  const linkButton = toolbarElement.querySelector("input[value='Link']")
  linkButton.className = "btn btn-primary btn-sm me-1"
  const unlinkButton = toolbarElement.querySelector("input[value='Unlink']")
  unlinkButton.className = "btn btn-outline-secondary btn-sm"

  new EmbedController(event.target)
})