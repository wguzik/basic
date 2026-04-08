import React, { useState, useEffect } from 'react';
import './App.css';

function App() {
  const [images, setImages] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetch('/api/images')
      .then(res => {
        if (!res.ok) return res.json().then(d => Promise.reject(d.error));
        return res.json();
      })
      .then(data => {
        setImages(data.images);
        setLoading(false);
      })
      .catch(err => {
        setError(err || 'Failed to load images');
        setLoading(false);
      });
  }, []);

  return (
    <div className="App">
      <header className="gallery-header">
        <h1>Basic Gallery</h1>
        {!loading && !error && (
          <span className="image-count">{images.length} image{images.length !== 1 ? 's' : ''}</span>
        )}
      </header>

      {loading && (
        <div className="status-container">
          <div className="spinner" />
          <p>Loading images...</p>
        </div>
      )}

      {error && (
        <div className="status-container error">
          <p>Failed to load images</p>
          <pre>{error}</pre>
        </div>
      )}

      {!loading && !error && images.length === 0 && (
        <div className="status-container">
          <p>No images found in the <code>images</code> container.</p>
        </div>
      )}

      {!loading && !error && images.length > 0 && (
        <div className="gallery-grid">
          {images.map(name => (
            <div key={name} className="gallery-item">
              <img
                src={`/api/image/${encodeURIComponent(name)}`}
                alt={name}
                loading="lazy"
                title={name}
              />
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

export default App;
