function [trial] = removeSaccades(trial)

trial.X_noSac = trial.eyeX_filt;
trial.Y_noSac = trial.eyeY_filt;
trial.DX_noSac = trial.eyeDX_filt;
trial.DY_noSac = trial.eyeDY_filt;
trial.DDX_noSac = trial.eyeDDX_filt;
trial.DDY_noSac = trial.eyeDDY_filt;
% trial.X_interpolSac = trial.eyeX_filt;
% trial.Y_interpolSac = trial.eyeY_filt;
% trial.DX_interpolSac = trial.eyeDX_filt;
% trial.DY_interpolSac = trial.eyeDY_filt;
% trial.DDX_interpolSac = trial.eyeDDX_filt;
% trial.DDY_interpolSac = trial.eyeDDY_filt;
trial.quickphases = false(trial.length,1);

if ~isempty(trial.saccades.X.fixOnsets)
    for i = 1:length(trial.saccades.X.fixOnsets)
        
        %        lengthSacX = trial.saccades.X.fixOffsets(i) - trial.saccades.X.fixOnsets(i);
        %         slopeX = (trial.eyeX_filt(trial.saccades.X.fixOffsets(i))-trial.eyeX_filt(trial.saccades.X.fixOnsets(i)))./lengthSacX;
        %         slopeDX = (trial.eyeDX_filt(trial.saccades.X.fixOffsets(i))-trial.eyeDX_filt(trial.saccades.X.fixOnsets(i)))./lengthSacX;
        %         slopeDDX = (trial.eyeDDX_filt(trial.saccades.X.fixOffsets(i))-trial.eyeDDX_filt(trial.saccades.X.fixOnsets(i)))./lengthSacX;
        %         slopeY = (trial.eyeY_filt(trial.saccades.X.fixOffsets(i))-trial.eyeY_filt(trial.saccades.X.fixOnsets(i)))./lengthSacX;
        %         slopeDY = (trial.eyeDY_filt(trial.saccades.X.fixOffsets(i))-trial.eyeDY_filt(trial.saccades.X.fixOnsets(i)))./lengthSacX;
        %         slopeDDY = (trial.eyeDDY_filt(trial.saccades.X.fixOffsets(i))-trial.eyeDDY_filt(trial.saccades.X.fixOnsets(i)))./lengthSacX;
        trial.X_noSac(trial.saccades.X.fixOnsets(i):trial.saccades.X.fixOffsets(i)) = 0;
        trial.Y_noSac(trial.saccades.X.fixOnsets(i):trial.saccades.X.fixOffsets(i)) = 0;
        trial.DX_noSac(trial.saccades.X.fixOnsets(i):trial.saccades.X.fixOffsets(i)) = 0;
        trial.DY_noSac(trial.saccades.X.fixOnsets(i):trial.saccades.X.fixOffsets(i)) = 0;
        trial.DDX_noSac(trial.saccades.X.fixOnsets(i):trial.saccades.X.fixOffsets(i)) = 0;
        trial.DDY_noSac(trial.saccades.X.fixOnsets(i):trial.saccades.X.fixOffsets(i)) = 0;
        
        %         for j = 1:lengthSacX+1
        %             trial.X_interpolSac(trial.saccades.X.fixOnsets(i)-1+j) = trial.eyeX_filt(trial.saccades.X.fixOnsets(i)) + slopeX*j;
        %             trial.Y_interpolSac(trial.saccades.X.fixOnsets(i)-1+j) = trial.eyeY_filt(trial.saccades.X.fixOnsets(i)) + slopeY*j;
        %             trial.DX_interpolSac(trial.saccades.X.fixOnsets(i)-1+j) = trial.eyeDX_filt(trial.saccades.X.fixOnsets(i)) + slopeDX*j;
        %             trial.DY_interpolSac(trial.saccades.X.fixOnsets(i)-1+j) = trial.eyeDY_filt(trial.saccades.X.fixOnsets(i)) + slopeDY*j;
        %             trial.DDX_interpolSac(trial.saccades.X.fixOnsets(i)-1+j) = trial.eyeDDX_filt(trial.saccades.X.fixOnsets(i)) + slopeDDX*j;
        %             trial.DDY_interpolSac(trial.saccades.X.fixOnsets(i)-1+j) = trial.eyeDDY_filt(trial.saccades.X.fixOnsets(i)) + slopeDDY*j;
        %         end
    end
end

if ~isempty(trial.saccades.Y.fixOnsets)
    for i = 1:length(trial.saccades.Y.fixOnsets)
        
      %  lengthSacY = trial.saccades.Y.fixOffsets(i) - trial.saccades.Y.fixOnsets(i);
%         slopeY = (trial.eyeY_filt(trial.saccades.Y.fixOffsets(i))-trial.eyeY_filt(trial.saccades.Y.fixOnsets(i)))./lengthSacY;
%         slopeDY = (trial.eyeDY_filt(trial.saccades.Y.fixOffsets(i))-trial.eyeDY_filt(trial.saccades.Y.fixOnsets(i)))./lengthSacY;
%         slopeDDY = (trial.eyeDDY_filt(trial.saccades.Y.fixOffsets(i))-trial.eyeDDY_filt(trial.saccades.Y.fixOnsets(i)))./lengthSacY;
%         slopeX = (trial.eyeX_filt(trial.saccades.Y.fixOffsets(i))-trial.eyeX_filt(trial.saccades.Y.fixOnsets(i)))./lengthSacY;
%         slopeDX = (trial.eyeDX_filt(trial.saccades.Y.fixOffsets(i))-trial.eyeDX_filt(trial.saccades.Y.fixOnsets(i)))./lengthSacY;
%         slopeDDX = (trial.eyeDDX_filt(trial.saccades.Y.fixOffsets(i))-trial.eyeDDX_filt(trial.saccades.Y.fixOnsets(i)))./lengthSacY;
            trial.X_noSac(trial.saccades.Y.fixOnsets(i):trial.saccades.Y.fixOffsets(i)) = 0;
            trial.Y_noSac(trial.saccades.Y.fixOnsets(i):trial.saccades.Y.fixOffsets(i)) = 0;
            trial.DX_noSac(trial.saccades.Y.fixOnsets(i):trial.saccades.Y.fixOffsets(i)) = 0;
            trial.DY_noSac(trial.saccades.Y.fixOnsets(i):trial.saccades.Y.fixOffsets(i)) = 0;
            trial.DDX_noSac(trial.saccades.Y.fixOnsets(i):trial.saccades.Y.fixOffsets(i)) = 0;
            trial.DDY_noSac(trial.saccades.Y.fixOnsets(i):trial.saccades.Y.fixOffsets(i)) = 0;
        
%         for j = 1:lengthSacY+1
%             trial.Y_interpolSac(trial.saccades.Y.fixOnsets(i)-1+j) = trial.eyeY_filt(trial.saccades.Y.fixOnsets(i)) + slopeY*j;
%             trial.X_interpolSac(trial.saccades.Y.fixOnsets(i)-1+j) = trial.eyeX_filt(trial.saccades.Y.fixOnsets(i)) + slopeX*j;
%             trial.DY_interpolSac(trial.saccades.Y.fixOnsets(i)-1+j) = trial.eyeDY_filt(trial.saccades.Y.fixOnsets(i)) + slopeDY*j;
%             trial.DX_interpolSac(trial.saccades.Y.fixOnsets(i)-1+j) = trial.eyeDX_filt(trial.saccades.Y.fixOnsets(i)) + slopeDX*j;
%             trial.DDY_interpolSac(trial.saccades.Y.fixOnsets(i)-1+j) = trial.eyeDDY_filt(trial.saccades.Y.fixOnsets(i)) + slopeDDY*j;
%             trial.DDX_interpolSac(trial.saccades.Y.fixOnsets(i)-1+j) = trial.eyeDDX_filt(trial.saccades.Y.fixOnsets(i)) + slopeDDX*j;
%         end
        
    end
end

end
