String getEpisodeIdFromUrl(String url) {
  return url.split('/').last.replaceAll('.html', '');
}