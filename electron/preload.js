const { contextBridge, ipcRenderer } = require('electron');

// Expose protected methods that allow the renderer process to use
// ipcRenderer without exposing the entire object
contextBridge.exposeInMainWorld('electron', {
  platform: process.platform,
  versions: process.versions,
  isElectron: true,
  
  // Add any additional APIs you need here
  openExternal: (url) => {
    ipcRenderer.send('open-external', url);
  }
});

// Make sure the app knows it's running in Electron
window.addEventListener('DOMContentLoaded', () => {
  console.log('Lampa running in Electron');
});
