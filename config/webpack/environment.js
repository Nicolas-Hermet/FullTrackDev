const { environment } = require('shakapacker')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')

// In production, extract CSS to standalone files. In dev, inject via style-loader.
const isProd = process.env.NODE_ENV === 'production'

// --- JavaScript (unchanged from your setup) ---
environment.loaders.append('babel', {
  test: /\.m?js$/,
  exclude: /node_modules/,
  use: {
    loader: 'babel-loader'
  }
})

// --- CSS ---
const cssRule = {
  test: /\.css$/i,
  use: [
    isProd ? MiniCssExtractPlugin.loader : 'style-loader',
    { loader: 'css-loader', options: { importLoaders: 1 } },
    'postcss-loader'
  ]
}

// --- SCSS/SASS ---
const scssRule = {
  test: /\.(scss|sass)$/i,
  use: [
    isProd ? MiniCssExtractPlugin.loader : 'style-loader',
    { loader: 'css-loader', options: { importLoaders: 2 } },
    'postcss-loader',
    'sass-loader'
  ]
}

environment.loaders.prepend('css', cssRule)
environment.loaders.prepend('scss', scssRule)

// --- Plugins ---
if (isProd) {
  environment.plugins.prepend(
    'MiniCssExtractPlugin',
    new MiniCssExtractPlugin({
      filename: 'css/[name]-[contenthash].css',
      chunkFilename: 'css/[id]-[contenthash].css'
    })
  )
}

module.exports = environment
