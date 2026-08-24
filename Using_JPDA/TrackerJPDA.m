dt = 0.2;
for time = 0:dt:30
    % Update the true positions of objects.
    pos_true = pos_true + V_true*dt;

    % Create detections of the two objects with noise.
    detection(1) = objectDetection(time,pos_true(:,1)+1*randn(3,1));
    detection(2) = objectDetection(time,pos_true(:,2)+1*randn(3,1));

    % Step the tracker through time with the detections.
    [confirmed,tentative,alltracks,info] = tracker(detection,time);

    % Extract position, velocity and label info.
    [pos,cov] = getTrackPositions(confirmed,positionSelector);
    vel = getTrackVelocities(confirmed,velocitySelector);
    meas = cat(2,detection.Measurement);
    measCov = cat(3,detection.MeasurementNoise);

    % Update the plot if there are any tracks.
    if numel(confirmed)>0
        labels = arrayfun(@(x)num2str([x.TrackID]),confirmed,'UniformOutput',false);
        trackP.plotTrack(pos,vel,cov,labels);
    end
    detectionP.plotDetection(meas',measCov);
    drawnow;

    % Display the cost and marginal probability of distribution every eight
    % seconds.
    if time>0 && mod(time,8) == 0
        disp(['At time t = ' num2str(time) ' seconds,']);
        disp('The cost of assignment was: ')
        disp(info.CostMatrix);
        disp(['Number of clusters: ' num2str(numel(info.Clusters))]);
        if numel(info.Clusters) == 1

            disp('The two tracks were in the same cluster.')
            disp('Marginal probabilities of association:')
            disp(info.Clusters{1}.MarginalProbabilities)
        end
        disp('-----------------------------')
    end
end