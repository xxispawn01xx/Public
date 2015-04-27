package edu.saintpeters.hdf5; /**
 * Created by nigeldefreitas on 3/3/2015.
 */

import java.io.File;

public class MillionSongDriver {

    private static final char[] ALPHABET = {'A', 'B', 'C', 'D', 'E', 'F', 'G',
            'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
            'U', 'V', 'W', 'X', 'Y', 'Z'};

    private static final int MAX_LETTERS = 26;

    private static boolean DEBUG = false;

    private static String datasetLocation = "Z:/Projects/St. Peters College - MySQL Class/Data/From EC2";
    private static char datasetFolder;

    public static void main(String[] args) {

        try {

            if (args != null && args.length == 2) {
                datasetLocation = args[0];
                datasetFolder = args[1].charAt(0);
            }
            else
            {
                System.out.println("Invalid command line args");
                return;
            }

            if (DEBUG)
                System.out.println("datasetLocation: " + datasetLocation);

            hdf5_getters_nigel_ii hdf5Util = new hdf5_getters_nigel_ii();

            for (int firstLevelIndex = 0; firstLevelIndex < MAX_LETTERS; firstLevelIndex++) {

                char firstPath;

                if(String.valueOf(datasetFolder) != null)
                {
                    firstPath = datasetFolder;
                    firstLevelIndex = MAX_LETTERS;
                }
                else {
                    firstPath = ALPHABET[firstLevelIndex];
                }

                for (int secondLevelIndex = 0; secondLevelIndex < MAX_LETTERS; secondLevelIndex++) {

                    char secondPath = ALPHABET[secondLevelIndex];

                    for (int thirdLevelIndex = 0; thirdLevelIndex < MAX_LETTERS; thirdLevelIndex++) {

                        char thirdPath = ALPHABET[thirdLevelIndex];

                        File f = null;
                        String[] files;


                        // create new file
                        String tempPath = datasetLocation + '/' + firstPath + '/' + secondPath + '/' + thirdPath;

                        if (DEBUG)
                            System.out.println("tempPath: " + tempPath);


                        f = new File(tempPath);

                        // array of files and directory
                        files = f.list();

                        if (files == null) {
                            if (DEBUG)
                                System.out.println("file list is empty at: "+tempPath);

                            continue;
                        }
                        // for each name in the path array
                        for (String file : files) {
                            // prints filename and directory name

                            if (DEBUG)
                                System.out.println(tempPath + '/' + file);

                            hdf5Util.printSong(tempPath + '/' + file);
                        }


                    }
                }
            }
        } catch (Exception e) {
            // if any error occurs
            e.printStackTrace();
        }

    }
}
