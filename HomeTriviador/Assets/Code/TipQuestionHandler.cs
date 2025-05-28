using System;
using System.Collections;
using System.Linq;
using System.Text;
using TMPro;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;

namespace Code
{
    public class TipQuestionHandler : MonoBehaviour
    {
        private string playerName;
        private string tipGameId;
        private GameHandler gameHandler;
        
        public TMP_InputField tipInputField;
        public TMP_Text questionText;
        public TMP_Text winningTipText;
        public TMP_Text tipText1;
        public TMP_Text tipText2;
        public TMP_Text tipText3;
        public Image tipImage1;
        public Image tipImage2;
        public Image tipImage3;
        
        // Start is called once before the first execution of Update after the MonoBehaviour is created
        void Start()
        {
            questionText.text = "Waiting for question...";
            winningTipText.text = "";
            tipText1.text = "";
            tipText2.text = "";
            tipText3.text = "";
            
            tipInputField.onSubmit.AddListener(delegate { StartCoroutine(SubmitTip()); });
            gameHandler = GameObject.FindGameObjectWithTag("Canvas").GetComponent<GameHandler>();
            
            playerName = PlayerPrefs.GetString("playerName");
            InvokeRepeating(nameof(StartCoroutineLoadResults), 2f, 5f);
            StartCoroutine(LoadTip());
        }

        void StartCoroutineLoadResults()
        {
            StartCoroutine(LoadResults());
        }

        IEnumerator LoadResults()
        {
            using var www = UnityWebRequest.Get("http://localhost:3000/game/currentTip");
            yield return www.SendWebRequest();

            if (www.result == UnityWebRequest.Result.Success)
            {
                var json = JsonUtility.FromJson<TipResultsJson>(www.downloadHandler.text);
                if (json.incomingTips.Length == 0) yield break;
                
                winningTipText.text = "Elvárt: " + json.winningTip;
                tipText1.text = json.incomingTips[0].name + "\n" + json.incomingTips[0].tip;
                tipText2.text = json.incomingTips[1].name + "\n" + json.incomingTips[1].tip;
                tipText3.text = json.incomingTips[2].name + "\n" + json.incomingTips[2].tip;
                tipImage1.color = json.incomingTips[0].ranking switch
                {
                    0 => Color.goldenRod,
                    1 => Color.silver,
                    _ => Color.saddleBrown
                };
                tipImage2.color = json.incomingTips[1].ranking switch
                {
                    0 => Color.goldenRod,
                    1 => Color.silver,
                    _ => Color.saddleBrown
                };
                tipImage3.color = json.incomingTips[2].ranking switch
                {
                    0 => Color.goldenRod,
                    1 => Color.silver,
                    _ => Color.saddleBrown
                };
                var myRank = json.incomingTips.Where(tip => tip.name == playerName).Select(tip => tip.ranking).FirstOrDefault();
                gameHandler.StartCoroutineEndPhase(myRank == 0 ? 2 : myRank == 1 ? 1 : 0);
            }
            else
            {
                Debug.Log("Error: " + www.error);
            }
        }
        
        IEnumerator LoadTip()
        {
            using var www = UnityWebRequest.Get("http://localhost:3000/game/nextTip");
            yield return www.SendWebRequest();

            if (www.result == UnityWebRequest.Result.Success)
            {
                var json = JsonUtility.FromJson<TipGameJson>(www.downloadHandler.text);
                tipGameId = json.id;
                questionText.text = json.question;
            }
            else
            {
                Debug.Log("Error: " + www.error);
            }
        }
        
        [Serializable]
        public class PostData
        {
            public string id;
            public string name;
            public int tip;
        }

        private IEnumerator SubmitTip()
        {
            tipInputField.enabled = false;
            
            var request = new UnityWebRequest("http://localhost:3000/game/tip", "POST");
            var bodyRaw = Encoding.UTF8.GetBytes(JsonUtility.ToJson(new PostData
            {
                id = tipGameId, 
                name = playerName, 
                tip = int.Parse(tipInputField.text)
            }));
            request.uploadHandler = new UploadHandlerRaw(bodyRaw);
            request.downloadHandler = new DownloadHandlerBuffer();
            request.SetRequestHeader("Content-Type", "application/json");
            yield return request.SendWebRequest();
            
            if (request.result != UnityWebRequest.Result.Success) 
            {
                Debug.LogError("Enter failed: " + request.error);
            }
        }

        // Update is called once per frame
        void Update()
        {
        }
    }
}
