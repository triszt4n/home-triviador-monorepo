using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

public class GameHandler : MonoBehaviour
{
    [SerializeField] private Color startingColor = Color.yellowNice; // The color to change to

    private List<Image> countyImages;
    
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        var images = gameObject.GetComponentsInChildren<Image>();
        countyImages = images.Where(image => image.name.Contains("County")).ToList();
        startingColor.a = 1;
        foreach (var image in countyImages)
        {
            image.color = startingColor;
            Debug.Log(image.color);
        }
    }

    // Update is called once per frame
    void Update()
    {
        foreach (var image in countyImages)
        {
            image.color = startingColor;
        }
    }
}
