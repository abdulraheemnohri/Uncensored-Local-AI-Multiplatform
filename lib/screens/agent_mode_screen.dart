import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import '../services/ai_agent_service.dart';

class AgentModeScreen extends StatefulWidget {
  const AgentModeScreen({super.key});

  @override
  State<AgentModeScreen> createState() => _AgentModeScreenState();
}

class _AgentModeScreenState extends State<AgentModeScreen> {
  final ChatController _chatController = Get.find();
  final AIAgentService _agentService = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Agent Mode'),
        actions: [
          Obx(() => Switch(
            value: _agentService.isAgentActive,
            onChanged: (value) {
              if (value) {
                _showAgentSelection();
              } else {
                _agentService.deactivateAgent();
              }
            },
          )),
        ],
      ),
      body: Column(
        children: [
          Obx(() => _agentService.isAgentActive
              ? _buildActiveAgentHeader()
              : _buildAgentSelectionPrompt()),
          const Divider(),
          Expanded(
            child: Obx(() => ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: true,
              itemCount: _chatController.messages.length,
              itemBuilder: (context, index) {
                final message = _chatController.messages[index];
                return _buildMessageBubble(message);
              },
            )),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildActiveAgentHeader() {
    final agent = _agentService.getCurrentAgent();
    if (agent == null) return const SizedBox();
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue[50],
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.blue),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Active: ' + agent.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                agent.description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showAgentSettings,
          ),
        ],
      ),
    );
  }

  Widget _buildAgentSelectionPrompt() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.grey[100],
      child: const Column(
        children: [
          Icon(Icons.robot, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'Select an AI Agent',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Choose from specialized agents for different tasks',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(dynamic message) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.green[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser && _agentService.isAgentActive)
              Text(
                _agentService.getCurrentAgent()?.name ?? 'AI',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.green,
                ),
              ),
            const SizedBox(height: 4),
            SelectableText(
              message.content,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAgentSelection,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: _agentService.isAgentActive
                    ? 'Message ' + (_agentService.getCurrentAgent()?.name ?? 'Agent')
                    : 'Select an agent first',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: _agentService.isAgentActive ? _sendMessage : null,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _agentService.isAgentActive ? _sendMessage : null,
            color: _agentService.isAgentActive ? Colors.blue : Colors.grey,
          ),
        ],
      ),
    );
  }

  void _showAgentSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildAgentSelectionSheet(),
    );
  }

  Widget _buildAgentSelectionSheet() {
    final agents = _agentService.getAvailableAgents();
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select AI Agent',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...agents.map((agent) => ListTile(
            leading: _getAgentIcon(agent.mode),
            title: Text(agent.name),
            subtitle: Text(agent.description),
            onTap: () {
              _agentService.activateAgent(agent.id);
              Navigator.pop(context);
            },
          )).toList(),
        ],
      ),
    );
  }

  Icon _getAgentIcon(AgentMode mode) {
    switch (mode) {
      case AgentMode.researcher:
        return const Icon(Icons.search, color: Colors.purple);
      case AgentMode.writer:
        return const Icon(Icons.edit, color: Colors.orange);
      case AgentMode.coder:
        return const Icon(Icons.code, color: Colors.green);
      case AgentMode.analyst:
        return const Icon(Icons.analytics, color: Colors.blue);
      default:
        return const Icon(Icons.auto_awesome, color: Colors.grey);
    }
  }

  void _showAgentSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildAgentSettingsSheet(),
    );
  }

  Widget _buildAgentSettingsSheet() {
    final agent = _agentService.getCurrentAgent();
    if (agent == null) return const SizedBox();
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Agent Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text('Name: ' + agent.name),
          Text('Description: ' + agent.description),
          const SizedBox(height: 16),
          const Text(
            'System Prompt:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              agent.systemPrompt,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              _agentService.deactivateAgent();
              Navigator.pop(context);
            },
            child: const Text('Deactivate Agent'),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    // Get message from text field
    // In a real implementation, this would be connected to a text controller
    // For now, we'll just show the agent is active
    if (_agentService.isAgentActive) {
      // The actual message sending would be handled by ChatController
      // with the agent's system prompt prepended
      Get.snackbar(
        'Agent Mode',
        'Sending message with ' + (_agentService.getCurrentAgent()?.name ?? 'Agent'),
      );
    }
  }
}