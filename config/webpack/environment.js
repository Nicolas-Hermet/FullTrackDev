const { environment } = require('shakapacker')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')

const isProd = process.env.NODE_ENV === 'production'

try { environment.loaders.delete('sass') } catch (e) {}
try { environment.loaders.delete('scss') } catch (e) {}
try { environment.loaders.delete('css') } catch (e) {}

environment.loaders.append('babel', {
  test: /\.m?js$/,
  exclude: /node_modules/,
  use: { loader: 'babel-loader' }
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

environment.loaders.append('css', cssRule)
environment.loaders.append('scss', scssRule)

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
