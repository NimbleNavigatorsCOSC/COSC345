$('a').each(function() {
    if (this.href.substring(0, 7) == 'mailto:') {
        this.href = this.href.replace(/\{at\}/g, '@').replace(/\{dot\}/g, '.');
        if (this.text.indexOf('{at}') > -1) {
            this.text = this.text.replace(/\{at\}/g, '@').replace(/\{dot\}/g, '.');
        }
    }
});
