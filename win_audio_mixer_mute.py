# from ctypes import cast, POINTER
# from comtypes import CLSCTX_ALL
# from pycaw.pycaw import AudioUtilities, IAudioEndpointVolume
# devices = AudioUtilities.GetSpeakers()
# interface = devices.Activate(
#     IAudioEndpointVolume._iid_, CLSCTX_ALL, None)
# volume = cast(interface, POINTER(IAudioEndpointVolume))
# volume.GetMute()
# volume.GetMasterVolumeLevel()
# volume.GetVolumeRange()
# # volume.SetMasterVolumeLevel(0.0, None)
# print(volume.GetMute())
# print(volume.GetMasterVolumeLevel())
# print(volume.GetVolumeRange())

# Get the process ID of the window you want to mute
from pycaw.pycaw import AudioUtilities

process_name = "librewolf.exe"

# Get the audio interface for the process
def main():
    sessions = AudioUtilities.GetAllSessions()
    for session in sessions:
        volume = session.SimpleAudioVolume
        if session.Process and session.Process.name() == process_name:
            if volume.GetMute(): # 1 or 0
                volume.SetMute(0,None)
            else:
                volume.SetMute(1,None)

if __name__=='__main__':
    main()
