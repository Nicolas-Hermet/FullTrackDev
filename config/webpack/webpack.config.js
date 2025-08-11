// See the shakacode/shakapacker README and docs directory for advice on customizing your webpackConfig.
const { generateWebpackConfig } = require('shakapacker')
const { merge } = require('webpack-merge')

// Add explicit support for .css and .scss so imports like '../css/application.scss' work reliably
const customConfig = {
  module: {
    rules: [
      {
        test: /\.s?css$/i,
        use: [
          // Order matters: inject styles, resolve CSS, then compile SASS
          'style-loader',
          'css-loader',
          'sass-loader'
        ]
      }
    ]
  },
  resolve: {
    extensions: ['.js', '.mjs', '.scss', '.css']
  }
}

module.exports = merge(generateWebpackConfig(), customConfig)
