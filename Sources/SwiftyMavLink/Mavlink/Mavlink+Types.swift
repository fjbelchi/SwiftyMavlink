//
//  SwiftyMavLink
//
//  Copyright © 2016 edronic. All rights reserved.

extension Mavlink {
    
    /// Micro air vehicle / autopilot classes. This identifies the individual model.
    public enum Autopilot: UInt8 {
        case Generic
        case Reserved
        case Slugs
        case ArdupilotMega
        case OpenPilot
        case GenericWayPointsOnly
        case GenericWayPointsAndSimpleNavigationOnly
        case GenericFullMission
        case Invalid
        case PPZ
        case UDB
        case FP
        case PX4
        case SMACCMPilot
        case AutoQuad
        case Armazila
        case Aerob
        case Asluav
    }
    
    public enum MavType: UInt8 {
        case Generic
        case FixedWing
        case Quadrotor
        case Coaxial
        case Helicopter
        case AntenaTracker
        case GCS
        case Airship
        case FreeBallon
        case Rocket
        case GroundRover
        case SurfaceBoat
        case Submarine
        case Hexarotor
        case Octorotor
        case Tricopter
        case FlappingWing
        case Kite
        case OnboardController
        case VtolDuorotor
        case VtolQuadrotor
        case VtolTiltrotor
        case VtolReserved2
        case VtolReserved3
        case VtolReserved4
        case VtolReserved5
        case Gimbal
        case Adsb
        case Unknown
    }
    
    ///These values define the type of firmware release. These values indicate the first version or release of this type.
    ///For example the first alpha release would be 64, the second would be 65.
    public enum Version: UInt8 {
        case Development = 0
        case Unknown
        case Alpha = 64
        case Beta = 128
        case ReleaseCandidate = 192
        case Official = 255
    }
    
    public struct ModeFlag: OptionSet {
        public let rawValue: UInt8
        public init(rawValue: UInt8) { self.rawValue = rawValue }
        
        static let None = ModeFlag(rawValue: 0)
        static let CustomEnabled = ModeFlag(rawValue: 1)
        static let TestEnabled = ModeFlag(rawValue: 2)
        static let AutoEnabled = ModeFlag(rawValue: 4)
        static let GuidedEnabled = ModeFlag(rawValue: 8)
        static let StabilizeEnabled = ModeFlag(rawValue: 16)
        static let HilEnabled = ModeFlag(rawValue: 32)
        static let ManualInputEnabled = ModeFlag(rawValue: 64)
        static let SafetyArmed = ModeFlag(rawValue: 128)
    }
    
    public enum State: UInt8 {
        case Uninitialized
        case Boot
        case Calibrating
        case StandBy
        case Active
        case Critical
        case Emergency
        case PowerOff
    }
    
    public struct SystemStatusSensor: OptionSet {
        public let rawValue: UInt32
        public init(rawValue: UInt32) { self.rawValue = rawValue }
        
        static let None = SystemStatusSensor(rawValue: 0)
        static let Gyro = SystemStatusSensor(rawValue: 1)
        static let Accelerometer = SystemStatusSensor(rawValue: 2)
        static let Magnetometer = SystemStatusSensor(rawValue: 4)
        static let AbsolutePressure = SystemStatusSensor(rawValue: 8)
        static let DifferentialPressure = SystemStatusSensor(rawValue: 16)
        static let GPS = SystemStatusSensor(rawValue: 32)
        static let OpticalFlow = SystemStatusSensor(rawValue: 64)
        static let VisionPosition = SystemStatusSensor(rawValue: 128)
        static let LaserPosition = SystemStatusSensor(rawValue: 256)
        static let ExternalGroundTruth = SystemStatusSensor(rawValue: 512)
        static let AngularRateControl = SystemStatusSensor(rawValue: 1024)
        static let AttitudeStabilization = SystemStatusSensor(rawValue: 2048)
        static let YawPosition = SystemStatusSensor(rawValue: 4096)
        static let ZAltitudeControl = SystemStatusSensor(rawValue: 8192)
        static let XYPositionControl = SystemStatusSensor(rawValue: 16384)
        static let MotorOutputs = SystemStatusSensor(rawValue: 32768)
        static let RCReceiver = SystemStatusSensor(rawValue: 65536)
        static let Gyro2 = SystemStatusSensor(rawValue: 131072)
        static let Accelerometer2 = SystemStatusSensor(rawValue: 262144)
        static let Magnetometer2 = SystemStatusSensor(rawValue: 524288)
        static let Geofence = SystemStatusSensor(rawValue: 1048576)
        static let AHRS = SystemStatusSensor(rawValue: 2097152)
        static let Terrain = SystemStatusSensor(rawValue: 4194304)
        static let ReverseMotor = SystemStatusSensor(rawValue: 8388608)
        
        static let All: SystemStatusSensor = [.Gyro,
                                              .Accelerometer,
                                              .Magnetometer,
                                              .AbsolutePressure,
                                              .DifferentialPressure,
                                              .GPS,
                                              .OpticalFlow,
                                              .VisionPosition,
                                              .ExternalGroundTruth,
                                              .AngularRateControl,
                                              .AttitudeStabilization,
                                              .YawPosition,
                                              .ZAltitudeControl,
                                              .MotorOutputs,
                                              .RCReceiver,
                                              .Gyro2,
                                              .Accelerometer2,
                                              .Magnetometer2,
                                              .Geofence,
                                              .AHRS,
                                              .Terrain,
                                              .ReverseMotor]
    }
    
}

