var autoprefixer = require('autoprefixer');
var merge = require('webpack-merge');
var path = require('path');
var precss = require('precss');
var webpack = require('webpack');
var CopyWebpackPlugin = require('copy-webpack-plugin');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var HtmlWebpackPlugin = require('html-webpack-plugin');

const PRODUCTION = 'production';
const DEVELOPMENT = 'development';

const TARGET_ENV = process.env.npm_lifecycle_event === 'build' ? PRODUCTION : DEVELOPMENT;
const ENTRY_PATH = path.join(__dirname, 'ui/js/app.js');
const OUTPUT_PATH = path.join(__dirname, 'dist');
const OUTPUT_FILENAME = (TARGET_ENV === PRODUCTION) ? '[name]-[hash].js' : '[name].js'

console.log(`Building for ${TARGET_ENV}`);

var commonConfig = {
  output: {
      path: OUTPUT_PATH,
      filename: `js/${OUTPUT_FILENAME}`
  },
  resolve: {
    extensions: ['.js', '.elm'],
    modules: ['node_modules']
  },
  module: {
    noParse: /\.elm$/,
    rules: [{
        test: /\.js$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['env']
          }
        }
      },{
          test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
          use: "url-loader?limit=10000&mimetype=application/font-woff"
      },{
          test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
          use: 'file-loader?publicPath=../../&name=css/[hash].[ext]'
    }]
  },
  plugins: [
    new webpack.LoaderOptionsPlugin({
      options: {
        postcss: [autoprefixer()]
      }
    }),
    new HtmlWebpackPlugin({
      template: 'ui/index.html',
      filename: 'index.html'
    })
  ]
};

var devConfig = {
  entry: [
    'webpack-dev-server/client?http://localhost:8080',
    ENTRY_PATH
  ],
  devServer: {
    historyApiFallback: true,
    contentBase: './ui',
    hot: true,
    proxy: [{
      context: ['/login', '/ws'],
      target: 'http://localhost:8081',
    }]
  },
  module: {
    rules: [{
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [{
            loader: 'elm-webpack-loader',
            options: {
              verbose: true,
              warn: true,
              debug: true
            }
        }]
      },{
        test: /\.scss$/,
        use: [
            'style-loader',
            'css-loader',
            {
              loader: 'postcss-loader',
              options: {
                plugins: function () {
                  return [precss, autoprefixer];
                }
              }
            }, 'sass-loader'
        ]
    }]
  }
};

var prodConfig = {
  entry: ENTRY_PATH,
  module: {
    rules: [{
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: 'elm-webpack-loader'
    }, {
        test: /\.scss$/,
        use: ExtractTextPlugin.extract({
            fallback: 'style-loader',
            use: [
                'css-loader',
                {
                  loader: 'postcss-loader',
                  options: {
                    plugins: function () {
                      return [precss, autoprefixer];
                  }}
                }, 'sass-loader'
            ]
        })
    }]
  },
  plugins: [
    new ExtractTextPlugin({
        filename: 'css/[name]-[hash].css',
        allChunks: true,
    }),
    new CopyWebpackPlugin([{
        from: 'ui/images/favicon.png',
        to: 'images/favicon.png'
    }])
  ]
};

module.exports = merge(commonConfig, (TARGET_ENV === PRODUCTION) ? prodConfig : devConfig);
