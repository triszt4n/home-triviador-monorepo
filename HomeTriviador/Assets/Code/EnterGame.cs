using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using TMPro;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;

namespace Code
{
    public class EnterGame : MonoBehaviour
    {
        public Button enterButton;
        public Button resetButton;
        public TMP_InputField nameInputField;
    
        // Start is called once before the first execution of Update after the MonoBehaviour is created
        void Start()
        {
            var btn = enterButton.GetComponent<Button>();
            btn.onClick.AddListener(OnEnterButtonClick);
            var resetBtn = resetButton.GetComponent<Button>();
            resetBtn.onClick.AddListener(OnResetButtonClick);
        }

        private void OnEnterButtonClick()
        {
            if (string.IsNullOrEmpty(nameInputField.text))
            {
                Debug.LogError("Name input field is empty. Please enter a name before resetting.");
            }
            else
            {
                StartCoroutine(Enter());
            }
        }

        private void OnResetButtonClick()
        {
            StartCoroutine(ResetGame());
        }

        private IEnumerator ResetGame()
        {
            using var www = UnityWebRequest.Post("http://localhost:3000/game/reset", new Dictionary<string, string>());
            yield return www.SendWebRequest();
            if (www.result != UnityWebRequest.Result.Success) 
            {
                Debug.LogError("Reset failed: " + www.error);
            }
        }
    
        [Serializable]
        public class PostData {
            public string name;
        }

        private IEnumerator Enter()
        {
            var request = new UnityWebRequest("http://localhost:3000/game/user", "POST");
            var bodyRaw = Encoding.UTF8.GetBytes(JsonUtility.ToJson(new PostData { name = nameInputField.text }));
            request.uploadHandler = new UploadHandlerRaw(bodyRaw);
            request.downloadHandler = new DownloadHandlerBuffer();
            request.SetRequestHeader("Content-Type", "application/json");
            yield return request.SendWebRequest();
            if (request.result != UnityWebRequest.Result.Success) 
            {
                Debug.LogError("Enter failed: " + request.error);
            }
            UnityEngine.SceneManagement.SceneManager.LoadScene("GameScene");
        }

        // Update is called once per frame
        void Update()
        {
        
        }
    }
}
