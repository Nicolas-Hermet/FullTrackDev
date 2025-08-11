const { environment } = require('shakapacker')

// Ensure Babel transpiles our JS (including class features plugins configured in babel.config.js)
environment.loaders.append('babel', {
  test: /\.m?js$/,
  exclude: /node_modules/,
  use: {
    loader: 'babel-loader'
  }
})

module.exports = environment
