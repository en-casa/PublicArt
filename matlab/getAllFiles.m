%{
n casale
adapted from
https://stackoverflow.com/questions/2652630/how-to-get-all-files-under-a-specific-directory-in-matlab
%}

function fileList = getAllFiles(dirName)

   % Get the data for the current directory
   dirData = dir(dirName);
   
   % Find the index for directories
   dirIndex = [dirData.isdir];
   
   % Get a list of the files
   fileList = {dirData(~dirIndex).name}';
   
   if ~isempty(fileList)
      %# Prepend path to files
      fileList = cellfun(@(x) fullfile(dirName,x),...
         fileList,'UniformOutput',false);
   end

end