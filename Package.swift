import PackageDescription

let package = Package(
  name:"SwiftyMavLink",
  targets: [Target(name: "SwiftyMavLink", dependencies:["Mavlink"])],
  dependencies:[
    .Package(url:"Sources/Mavlink", majorVersion:0),
    .Package(url: "https://github.com/czechboy0/Socks.git", majorVersion: 0, minor: 7)
  ]
)
