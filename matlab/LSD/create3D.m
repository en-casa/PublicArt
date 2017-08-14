function create3D(fig, WO, xref, yref, zref, outfile)

% CREATE3D Generate VRML model file from X,Y,Z homology views
% -----------------------------------------------------------------------------

   x = norm(xref(1:2) - WO(1:2));
   y = norm(yref(1:2) - WO(1:2));
   z = norm(zref(1:2) - WO(1:2));

   % Define the object vertices
   vertex(1,:) = [0, 0, z];
   vertex(2,:) = [0, x, z];
   vertex(3,:) = [y, x, z];
   vertex(4,:) = [y, 0, z];
   vertex(5:8,1:2) = vertex(1:4,1:2);
   vertex(5:8,3) = 0;

   % Model each face of the object
   face = {'0 3 2 1 -1 7 4 5 6 -1';  % front and back faces (x-y planes)
           '0 1 5 4 -1 7 6 2 3 -1';  % left and right faces (x-z planes)
           '0 4 7 3 -1 2 6 5 1 -1'}; % top and bottom faces (y-z planes)
   
   % Define the texture file names
   texfile = {'xyplane.png','xzplane.png','yzplane.png'};
   texCoordIndex = [1 0 3 2];
   
   % Write the VRML model file
   fh = fopen(outfile,'w');
   fprintf(fh,'#X3D V3.0 utf8\n\n');
   fprintf(fh,'Group {\n  children [\n');
   
   for s = 1:3
      tci = circshift(texCoordIndex,-s,2);

      fprintf(fh,'    Shape {\n');
      fprintf(fh,'      appearance Appearance {\n');
      fprintf(fh,'        texture ImageTexture {\n');
      fprintf(fh,'          url ["%s"]\n',texfile{s});
      fprintf(fh,'          repeatS FALSE\n');
      fprintf(fh,'          repeatT FALSE } }\n');
      fprintf(fh,'      geometry IndexedFaceSet {\n');
      
      if s == 1
         fprintf(fh,'        coord DEF vertices Coordinate {\n');
         fprintf(fh,'          point [\n');
         for k = 1:8
            fprintf(fh,'            %5.3f %5.3f %5.3f\n',vertex(k,:)./1000);
         end
         fprintf(fh,'        ] }\n');
      else
         fprintf(fh,'           coord USE vertices\n');
      end
      
      fprintf(fh,'        coordIndex [%s]\n',face{s});
      fprintf(fh,'        texCoord TextureCoordinate {\n');
      fprintf(fh,'          point [ 0 0, 1 0, 1 1, 0 1 ] }\n');
      fprintf(fh,'        texCoordIndex [\n');
      fprintf(fh,'          %d %d %d %d -1\n',tci);
      fprintf(fh,'          %d %d %d %d -1\n',tci(4:-1:1));
      fprintf(fh,'        ] } }\n\n');
   end
   
   fprintf(fh,'  ] }\n\n');
   fprintf(fh,'NavigationInfo { type "EXAMINE" }\n');
   fprintf(fh,'Viewpoint { position 0 0 5 }\n');
   fclose(fh);
end
