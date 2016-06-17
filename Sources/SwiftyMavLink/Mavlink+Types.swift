
public class Mavlink {
    
}

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

//TODO : Add bit operations
  public enum ModeFlag: UInt8 {
    case Unknown = 0
    case CustomEnabled = 1
    case TestEnabled = 2
    case AutoEnabled = 4
    case GuidedEnabled = 8
    case StabilizeEnabled = 16
    case HilEnabled = 32
    case ManualInputEnabled = 64
    case SafetyArmed = 128
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

}

