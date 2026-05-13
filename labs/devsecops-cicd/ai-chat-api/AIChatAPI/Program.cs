using OpenAI;
using OpenAI.Chat;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

var apiKey = builder.Configuration["OpenAI:ApiKey"];
var client = new ChatClient("gpt-4o-mini", apiKey);

app.MapPost("/chat", async (ChatRequest req) =>
{
    var response = await client.CompleteChatAsync(req.Prompt);
    return response.Value.Content[0].Text;
});

app.Run();

record ChatRequest(string Prompt);