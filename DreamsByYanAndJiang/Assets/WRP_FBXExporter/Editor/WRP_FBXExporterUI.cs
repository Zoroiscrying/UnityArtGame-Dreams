using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.IO;

public class FBXExporterUI : EditorWindow
{

	#region variables
	private bool addObjectsInHierarchy = true;
	private Vector2 scrollPos = new Vector2(0, 0);
	private string pathForFBX = "";
	private string fbxName = "FBXMesh";
	private string folderPathForFBX = "";
    
	#endregion

	[ MenuItem( "We.R.Play/FBX Exporter" ) ]
	public static void ShowWindow()
	{
        FBXExporterUI window = (FBXExporterUI)EditorWindow.GetWindow( typeof( FBXExporterUI ), false, "FBX Exporter");
		window.Show();
	}

	void OnEnable()
	{
      	SetPath ();
        
	}
	
	void OnGUI()
	{
		EditorGUILayout.Separator();
		GUILayout.Label( "Select options and hit apply..." );
		EditorGUILayout.Separator();

        addObjectsInHierarchy = EditorGUILayout.Toggle("Add Objects in heirarchy", addObjectsInHierarchy);

		EditorGUILayout.Separator();EditorGUILayout.Separator();EditorGUILayout.Separator();

		GameObject[] objectsToCombine = FBXExporter.GetObjectsToCombine(Selection.gameObjects, addObjectsInHierarchy);
		SetName (objectsToCombine);
		string objectsToString = "";
		for (int i = 0; i < objectsToCombine.Length; i++)
		{
			objectsToString+=objectsToCombine[i].name;
			if(i<objectsToCombine.Length-1)
				objectsToString+="\n";
		}
		EditorGUILayout.LabelField("Selected Objects : "+objectsToCombine.Length);
		scrollPos = EditorGUILayout.BeginScrollView(scrollPos, GUILayout.Width (200), GUILayout.Height (80));

        EditorGUILayout.TextArea(objectsToString);

		EditorGUILayout.EndScrollView();

		EditorGUILayout.Separator();

		EditorGUILayout.BeginHorizontal();
        pathForFBX = EditorGUILayout.TextArea(pathForFBX, GUILayout.MaxWidth(250));

			if (GUILayout.Button ("Browse", GUILayout.MaxWidth (80))) 
				{
					if (EditorGUILayout.TextField(pathForFBX, GUILayout.MaxWidth(250)) == "") 
						{
							pathForFBX = EditorUtility.OpenFolderPanel("Assets",Application.dataPath,"");

							if (pathForFBX != "")
								{
									if (CheckIfPathForFBXIsOutsideAssetFolder(pathForFBX) == true)
										{
											pathForFBX = pathForFBX.Substring(pathForFBX.LastIndexOf("Assets"));
											EditorGUILayout.TextField(pathForFBX, GUILayout.MaxWidth(250));
										} 
									else
										{
											ShowWarningDialogue();
										}
								} 
							else
								{
									pathForFBX = Application.dataPath.Substring( Application.dataPath.IndexOf("Assets"));
								}
						}

					else if (Directory.Exists (pathForFBX)) 
						{
							string existingPath = pathForFBX;
							pathForFBX = EditorUtility.OpenFolderPanel("Assets",pathForFBX,"");

							if (pathForFBX != "")
								{
									if (CheckIfPathForFBXIsOutsideAssetFolder(pathForFBX) == true)
										{
											pathForFBX = pathForFBX.Substring(pathForFBX.LastIndexOf("Assets"));
											EditorGUILayout.TextField(pathForFBX, GUILayout.MaxWidth(250));
									} else
										{
											ShowWarningDialogue();
										}
								}
							else
								{
									pathForFBX = existingPath;
								}

						} 
					else 
						{
							bool optionSelected = false;

							optionSelected = EditorUtility.DisplayDialog ("Create Directory", "Directory doesn't exists, would you like to create this directory?", "Yes", "No");

							if (optionSelected)
								{
									string pathfromAssets = pathForFBX.Substring(pathForFBX.LastIndexOf("Assets"));
									Directory.CreateDirectory(pathfromAssets);
									EditorUtility.OpenFolderPanel("", pathfromAssets, "");
									EditorGUILayout.TextField(pathForFBX, GUILayout.MaxWidth(250));
								} 
							else
								{
									pathForFBX =EditorUtility.OpenFolderPanel("", "Assets", "");

									if (pathForFBX != "")
										{
											if (CheckIfPathForFBXIsOutsideAssetFolder(pathForFBX) == true)
												{
													EditorGUILayout.TextField(pathForFBX, GUILayout.MaxWidth(250));
												}
										} 
									else
										{
											pathForFBX = Application.dataPath.Substring(Application.dataPath.IndexOf("Assets"));
										}

								}

						}
					EditorGUILayout.TextField(pathForFBX, GUILayout.MaxWidth(250));
					EditorGUILayout.TextArea (pathForFBX, GUILayout.MaxWidth (250));
					AssetDatabase.SaveAssets ();
					AssetDatabase.Refresh (ImportAssetOptions.ImportRecursive);
		}
		EditorGUILayout.EndHorizontal ();
		if( GUILayout.Button( "Export" ) )
		{
			folderPathForFBX = pathForFBX.Replace("Assets", "");
			folderPathForFBX = folderPathForFBX.Replace("/"+fbxName+".fbx", "");

			CallRelevantFunction();

		}
	}
	private void CallRelevantFunction()
	{
		FBXExporter.ExportFBX(fbxName,folderPathForFBX, Selection.gameObjects, addObjectsInHierarchy);
	}
	private void ShowWarningDialogue()
	{
		EditorUtility.DisplayDialog ("Warning", "Folder must be inside Assets directory", "Ok");
		SetPath ();
	}

	private void SetPath()
	{
		pathForFBX = "Assets/WRP_Exports";
	}

	private void SetName(GameObject[] actualObjects)
	{
		fbxName = "FBXMesh";
		if(addObjectsInHierarchy)
		{
			if (Selection.gameObjects != null && Selection.gameObjects.Length > 0)
			{
				fbxName = Selection.gameObjects [0].name;
			}
		}
		else
		{
			if (actualObjects != null && actualObjects.Length == 1) 
			{
				fbxName = actualObjects [0].name;
			}
			else if(actualObjects != null && actualObjects.Length > 1)
			{
				fbxName = "FBXMesh";
			}
		}
	}

	private bool CheckIfPathForFBXIsOutsideAssetFolder(string path)
	{
		bool contains = false;

		if (path.Contains ("Assets")) 
		{
			string pathfromAssets = path.Substring (path.LastIndexOf ("Assets"));

			if (AssetDatabase.IsValidFolder (pathfromAssets)) {
				contains = true;
			} else {
				contains = false;
			}
		}

		return contains;
	}
	
}