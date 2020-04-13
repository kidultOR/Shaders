using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CookBook_9_ProceduralTexture_3 : MonoBehaviour
{
    #region Public Variables
    //С помощью этих переменных мы сможем изменять размер
    //текстуры, а также видеть её в редакторе
    public int widthHeight = 512;
    public Texture2D generatedTexture;
    #endregion
    #region Private Variables
    //Внутренние переменные скрипта
    private Material currentMaterial;
    private Vector2 centerPosition;
    #endregion
    // Start is called before the first frame update
    void Start()
    {
        //Проверяем, есть ли на этом объекте материал
        if (!currentMaterial)
        {
            currentMaterial = GetComponent<Renderer>().sharedMaterial; //renderer.sharedMaterial;
            if (!currentMaterial)
            {
                Debug.LogWarning("Cannot find a material on: "
                + transform.name);
            }
        }

        //Генерируем процедурную текстуру
        if (currentMaterial)
        {
            //Генерируем текстуру градиента
            centerPosition = new Vector2(0.5f, 0.5f);
            generatedTexture = GenerateGradient();
            //Присваиваем её материалу текущего объекта
            currentMaterial.SetTexture("_MainTex", generatedTexture);
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private Texture2D GenerateGradient()
    {
        //Создадим новую Texture2D
        Texture2D proceduralTexture = new Texture2D(widthHeight, widthHeight);
        //Узнаём центр текстуры
        Vector2 centerPixelPosition = centerPosition * widthHeight;
        //Пройдёмся по всем пикселям, определим их расстояние от
        //центра и на основе этого присвоим им значения.
        for (int x = 0; x < widthHeight; x++)
        {
            for (int y = 0; y < widthHeight; y++)
            {
                //Вычисляем расстояние от центра текстуры до выбранного пикселя
                Vector2 currentPosition = new Vector2(x, y);
                float pixelDistance = Vector2.Distance (currentPosition, centerPixelPosition) / (widthHeight * 0.5f);
                //Инвертируем значения и ограничиваем их диапазоном [0, 1]
                pixelDistance = Mathf.Abs(1 - Mathf.Clamp(pixelDistance, 0f, 1f));

                Vector2 pixelDirection = centerPixelPosition - currentPosition; 
                pixelDirection.Normalize();
                float rightDirection = Vector2.Dot(pixelDirection, Vector2.right);
                float leftDirection = Vector2.Dot(pixelDirection, -Vector2.right);
                float upDirection = Vector2.Dot(pixelDirection, Vector2.up);


                //Создаём новый цвет пикселя
                Color pixelColor = new Color(rightDirection, leftDirection, upDirection, 1.0f);
                proceduralTexture.SetPixel(x, y, pixelColor);
            }
        }
        //И наконец, записываем все изменения в текстуру
        proceduralTexture.Apply();
        //Возврашаем текстуру в основную программу.
        return proceduralTexture;
    }
}
