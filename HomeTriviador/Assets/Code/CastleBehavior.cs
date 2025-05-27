using UnityEngine;
using UnityEngine.UI;

namespace Code
{
    public class CastleBehavior : MonoBehaviour
    {
        public Image castleImage1;
        public Image castleImage2;
        public Image castleImage3;
        public Color startingColor = Color.red;
        
        // Start is called once before the first execution of Update after the MonoBehaviour is created
        void Start()
        {
            castleImage1.color = startingColor;
            castleImage2.color = startingColor;
            castleImage3.color = startingColor;
            startingColor.a = 1; // Set the alpha to 0.1 for transparency
        }

        // Update is called once per frame
        void Update()
        {
        
        }
    }
}
