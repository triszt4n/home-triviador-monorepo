using TMPro;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;

public class EnterGame : MonoBehaviour
{
    public Button enterButton;
    public Button resetButton;
    public TMP_InputField nameInputField;
    
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        Button btn = enterButton.GetComponent<Button>();
        btn.onClick.AddListener(OnEnterButtonClick);
        Button resetBtn = resetButton.GetComponent<Button>();
        resetBtn.onClick.AddListener(OnResetButtonClick);
    }
    
    // This method is called when the enter button is clicked
    void OnEnterButtonClick()
    {
        // Load the game scene
        UnityEngine.SceneManagement.SceneManager.LoadScene("GameScene");
    }
    // This method is called when the reset button is clicked
    void OnResetButtonClick()
    {
        // Reset the game state or reload the current scene
        Debug.Log(nameInputField.text);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
