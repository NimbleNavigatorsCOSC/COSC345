import 'dart:html';

void main() {
  querySelectorAll('a[href^="mailto:"]').forEach((emailLinkElem) {
    emailLinkElem.attributes['href'] = emailLinkElem.attributes['href']
        .replaceAll('\(at\)', '@')
        .replaceAll('\(dot\)', '.');
    emailLinkElem.text =
        emailLinkElem.text.replaceAll('\(at\)', '@').replaceAll('\(dot\)', '.');
  });
}
