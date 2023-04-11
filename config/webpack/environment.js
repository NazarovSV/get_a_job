const { environment } = require('@rails/webpacker')

// Add the following lines
const webpack = require("webpack")

environment.plugins.append("Provide", new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    Pagy: 'pagy',
    Popper: ['popper.js', 'default']
}))

module.exports = environment
