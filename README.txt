You need Matlab to run these codes with nirs-toolbox to run most of the processing
Homer2 is recomended to run BlockAvg with fnirs data.

Start with integracao_eeg_fnirs_escrita or integracao_eeg_fnirs_finger code. 
Chage directories in the main code to apply to your data.

Folders containing participants data must be organized in these fashion:

Example 1:
      <root folder> / <Group 1> /
                                   <subject A>/ files.nirs
                                   <subject B>/ files.nirs
                    / <Group 2> /
                                   <subject C>/ files.nirs
                                   <subject D>/ files.nirs

Main Code and auxiliary functions were created by A.J.M Paulo