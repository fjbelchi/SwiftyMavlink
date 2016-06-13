import PackageDescription

let package = Package(
  name:"SwiftyMavLink",
  targets: [Target(name: "SwiftyMavLink", dependencies:["Mavlink"])],
  dependencies:[
    .Package(url:"Sources/Mavlink", majorVersion:0)
  ]
)
