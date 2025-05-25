using UnityEngine;
using UnityEngine.UI;

public class EnterGame : MonoBehaviour
{
    public Button enterButton;
    
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        Button btn = enterButton.GetComponent<Button>();
        btn.onClick.AddListener(OnEnterButtonClick);
    }
    
    // This method is called when the enter button is clicked
    void OnEnterButtonClick()
    {
        // Load the game scene
        UnityEngine.SceneManagement.SceneManager.LoadScene("GameScene");
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
