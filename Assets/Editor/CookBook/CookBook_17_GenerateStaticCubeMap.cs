using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class CookBook_17_GenerateStaticCubeMap : ScriptableWizard
{
    public Transform renderPosition;
    public Cubemap cubemap;

    void OnWizardUpdate()
    {
        helpString = "Select transform to render from and cubemap to render into";
        if (renderPosition != null && cubemap != null)
        {
            isValid = true;
        }
        else
        {
            isValid = false;
        }
    }

    void OnWizardCreate()
    {
        //Создадим временную камеру для рендеринга
        //GameObject go = new GameObject("CubeCam", typeof(Camera));
        Camera go = new Camera();
        //Разместим её в нужном месте
        go.transform.position = renderPosition.position;
        go.transform.rotation = Quaternion.identity;
        //Отрендерим кубмап
        go.RenderToCubemap(cubemap);
        //Уничтожим временную камеру
        DestroyImmediate(go);
    }

    [MenuItem("CookBook/Render Cubemap")]
    static void RenderCubemap()
    {
        ScriptableWizard.DisplayWizard("Render CubeMap", typeof(CookBook_17_GenerateStaticCubeMap), "Render!");
    }
}
