var webpack = require('webpack')

module.exports = {
  entry: './maze.js',
  output: {
    filename: 'maze.min.js',
    library: 'Maze'
  },
  module: {
    loaders: [
      {
        test: /\.js?$/,
        exclude: /node_modules/,
        loader: 'babel-loader',
        query: {
          presets: ['env']
        }
      }
    ]
  },
  plugins: [
    new webpack.optimize.UglifyJsPlugin({
      compress: { warnings: false }
    })
  ]
};
