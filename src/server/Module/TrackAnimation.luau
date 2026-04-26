local TrackAnimation = {}

function TrackAnimation.startRepairAnimation(trackStart, trackFixing)
	trackStart:Play()
	
	trackStart.Stopped:Wait()
	
	trackFixing.Play()
end

function TrackAnimation.stopRepairAnimation(trackFixing, trackStop)
	trackFixing:Stop(0.5)
	trackStop:Play()
end

return TrackAnimation
