import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import '../models/chat_message.dart';

enum AgentMode {
  standard,
  researcher,
  writer,
  coder,
  analyst,
  custom
}

class AgentConfig {
  final String id;
  final String name;
  final String description;
  final String systemPrompt;
  final AgentMode mode;
  final Map<String, dynamic> parameters;

  AgentConfig({
    required this.id,
    required this.name,
    required this.description,
    required this.systemPrompt,
    required this.mode,
    this.parameters = const {},
  });
}

class AIAgentService extends GetxService {
  final Uuid _uuid = const Uuid();
  final Map<String, AgentConfig> _agents = {};
  String? _currentAgentId;
  bool _isAgentActive = false;

  Map<String, AgentConfig> get agents => _agents;
  String? get currentAgentId => _currentAgentId;
  bool get isAgentActive => _isAgentActive;

  @override
  void onInit() {
    super.onInit();
    _initializeDefaultAgents();
  }

  void _initializeDefaultAgents() {
    _agents['researcher'] = AgentConfig(
      id: 'researcher',
      name: 'Researcher',
      description: 'Deep research and analysis agent',
      systemPrompt: '''
        You are a Researcher AI Agent. Your task is to:
        1. Conduct thorough research on any topic
        2. Provide detailed, well-structured analysis
        3. Cite sources when possible
        4. Maintain objectivity and depth
        5. Answer in comprehensive paragraphs
      ''',
      mode: AgentMode.researcher,
      parameters: {
        'depth': 'deep',
        'sources': 5,
        'format': 'detailed'
      },
    );

    _agents['writer'] = AgentConfig(
      id: 'writer',
      name: 'Writer',
      description: 'Creative writing and content generation agent',
      systemPrompt: '''
        You are a Writer AI Agent. Your task is to:
        1. Generate creative and engaging content
        2. Adapt to various writing styles (formal, casual, technical, etc.)
        3. Produce well-structured, grammatically correct text
        4. Be original and thoughtful
        5. Follow user instructions precisely
      ''',
      mode: AgentMode.writer,
      parameters: {
        'style': 'creative',
        'tone': 'neutral',
        'length': 'medium'
      },
    );

    _agents['coder'] = AgentConfig(
      id: 'coder',
      name: 'Coder',
      description: 'Code generation and analysis agent',
      systemPrompt: '''
        You are a Coder AI Agent. Your task is to:
        1. Write clean, efficient, and well-documented code
        2. Support multiple programming languages
        3. Explain code concepts clearly
        4. Debug and optimize existing code
        5. Follow best practices and standards
        6. Provide complete, runnable examples
      ''',
      mode: AgentMode.coder,
      parameters: {
        'language': 'python',
        'style': 'clean',
        'comments': true
      },
    );

    _agents['analyst'] = AgentConfig(
      id: 'analyst',
      name: 'Analyst',
      description: 'Data analysis and problem-solving agent',
      systemPrompt: '''
        You are an Analyst AI Agent. Your task is to:
        1. Analyze data and identify patterns
        2. Solve complex problems step-by-step
        3. Provide data-driven insights
        4. Create visualizations and explanations
        5. Be logical and methodical
      ''',
      mode: AgentMode.analyst,
      parameters: {
        'approach': 'analytical',
        'detail': 'high',
        'visualizations': true
      },
    );
  }

  AgentConfig? getAgent(String agentId) {
    return _agents[agentId];
  }

  AgentConfig? getCurrentAgent() {
    if (_currentAgentId == null) return null;
    return _agents[_currentAgentId!];
  }

  Future<void> activateAgent(String agentId) async {
    if (!_agents.containsKey(agentId)) {
      throw Exception('Agent not found: ' + agentId);
    }
    
    _currentAgentId = agentId;
    _isAgentActive = true;
    update();
  }

  Future<void> deactivateAgent() async {
    _currentAgentId = null;
    _isAgentActive = false;
    update();
  }

  String createAgentSession() {
    return _uuid.v4();
  }

  String getAgentSystemPrompt(String agentId) {
    final agent = _agents[agentId];
    if (agent == null) {
      return '';
    }
    return agent.systemPrompt;
  }

  Map<String, dynamic> getAgentParameters(String agentId) {
    final agent = _agents[agentId];
    if (agent == null) {
      return {};
    }
    return agent.parameters;
  }

  Future<void> updateAgentParameters(String agentId, Map<String, dynamic> newParams) async {
    if (!_agents.containsKey(agentId)) {
      throw Exception('Agent not found: ' + agentId);
    }
    
    _agents[agentId] = AgentConfig(
      id: _agents[agentId]!.id,
      name: _agents[agentId]!.name,
      description: _agents[agentId]!.description,
      systemPrompt: _agents[agentId]!.systemPrompt,
      mode: _agents[agentId]!.mode,
      parameters: {..._agents[agentId]!.parameters, ...newParams},
    );
    
    update();
  }

  Future<void> addCustomAgent(AgentConfig config) async {
    _agents[config.id] = config;
    update();
  }

  Future<void> removeCustomAgent(String agentId) async {
    if (_agents.containsKey(agentId) && !['researcher', 'writer', 'coder', 'analyst'].contains(agentId)) {
      _agents.remove(agentId);
      if (_currentAgentId == agentId) {
        _currentAgentId = null;
        _isAgentActive = false;
      }
      update();
    }
  }

  List<AgentConfig> getAvailableAgents() {
    return _agents.values.toList();
  }

  @override
  void onClose() {
    deactivateAgent();
    super.onClose();
  }
}