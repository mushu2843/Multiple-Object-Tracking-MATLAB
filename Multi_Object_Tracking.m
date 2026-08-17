clc;
clear;
close all;

detector = vehicleDetectorACF("front-rear-view");

vReader = VideoReader("05_highway_lanechange_25s.mp4");

trackPlayer = vision.VideoPlayer( ...
    Position=[700 400 700 400]);

tracker = multiObjectTracker( ...
    FilterInitializationFcn=@helperInitDemoFilter, ...
    AssignmentThreshold=30, ...
    DeletionThreshold=15, ...
    ConfirmationThreshold=[3 5]);

measurementNoise = 100;
frameCount = 1;

while hasFrame(vReader)

    frame = readFrame(vReader);

    [bboxes,scores] = detect(detector,frame);

    bboxes = bboxes(scores > 5,:);

    centroids = [ ...
        bboxes(:,1) + floor(bboxes(:,3)/2), ...
        bboxes(:,2) + floor(bboxes(:,4)/2)];

    numDetections = size(centroids,1);

    detections = cell(numDetections,1);

    for i = 1:numDetections

        detections{i} = objectDetection( ...
            frameCount, ...
            centroids(i,:)', ...
            MeasurementNoise=measurementNoise, ...
            ObjectAttributes=struct( ...
                BoundingBox=bboxes(i,:)), ...
            ObjectClassID=1);

    end

    confirmedTracks = tracker( ...
        detections,frameCount);

    displayTrackingResults( ...
        trackPlayer, ...
        confirmedTracks, ...
        frame);

    frameCount = frameCount + 1;

end


function filter = helperInitDemoFilter(detection)

    state = [ ...
        detection.Measurement(1);
        0;
        detection.Measurement(2);
        0];

    stateCov = diag([ ...
        detection.MeasurementNoise(1,1), ...
        detection.MeasurementNoise(1,1)*100, ...
        detection.MeasurementNoise(2,2), ...
        detection.MeasurementNoise(2,2)*100]);

    filter = trackingKF( ...
        'MotionModel','2D Constant Velocity', ...
        'State',state, ...
        'StateCovariance',stateCov, ...
        'MeasurementNoise',detection.MeasurementNoise);

end


function displayTrackingResults(videoPlayer,confirmedTracks,frame)

    if ~isempty(confirmedTracks)

        numRelTr = numel(confirmedTracks);

        boxes = zeros(numRelTr,4);
        ids = zeros(numRelTr,1,'int32');

        predictedTrackInds = zeros(numRelTr,1);

        for tr = 1:numRelTr

            boxes(tr,:) = ...
                confirmedTracks(tr).ObjectAttributes.BoundingBox;

            ids(tr) = ...
                confirmedTracks(tr).TrackID;

            if confirmedTracks(tr).IsCoasted
                predictedTrackInds(tr) = tr;
            end

        end

        predictedTrackInds = ...
            predictedTrackInds(predictedTrackInds > 0);

        labels = cellstr(int2str(ids));

        isPredicted = cell(size(labels));

        isPredicted(predictedTrackInds) = ...
            {' predicted'};

        labels = strcat(labels,isPredicted);

        frame = insertObjectAnnotation( ...
            frame, ...
            "rectangle", ...
            boxes, ...
            labels);

    end

    videoPlayer.step(frame);

end