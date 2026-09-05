export function godotLogFailed(text: string) {
  return text.split(/\r?\n/).some((line) => {
    if (/SCRIPT ERROR:/.test(line)) return true;
    if (/WARNING:.*leak/.test(line) && !/leaked at exit/.test(line)) return true;
    if (/ERROR:/.test(line) && !/resources still in use at exit/.test(line)) return true;
    return false;
  });
}
