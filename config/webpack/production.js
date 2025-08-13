// See the shakacode/shakapacker README and docs directory for advice on customizing your webpackConfig.
const { generateWebpackConfig } = require('shakapacker')
const { merge } = require('webpack-merge')

// Do NOT redefine CSS/SCSS rules here. Those are configured in config/webpack/environment.js
module.exports = merge(generateWebpackConfig(), {
  resolve: {
    extensions: ['.js', '.mjs', '.scss', '.css']
  }
})
