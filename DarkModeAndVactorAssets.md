#  Dark mode & Vector assets

## Using a different image for light/dark mode:

With pdf's, there is no loss of resolution when zooming in. This is the reason they are used in this app. 

In Assets.xcassets:
- pull PDF into background
- Toggle "Preserve vector data" on
- Set "appearances" in attributes to "Any, light, dark"
- Set "scales" to Single Scale
- Move light and dark pdf to correct field


## Using different colors for text/icons in dark/light mode:

- Create a new XCAsset: Color set
- Set "appearances" in attributes to "Any, light, dark"
- Using the color picker tool or using rgba values, set the values for the light and dark modes.
- In storyboard, you can select the custom color which will change when the mode changes.
